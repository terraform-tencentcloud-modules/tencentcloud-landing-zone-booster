################################################################################
### Redis Instance, Backup Config, SSL Config
################################################################################

# Get availability zones for Redis product
data "tencentcloud_availability_zones_by_product" "az" {
  count   = length(var.redis.replica_zone_names) > 0 ? 1 : 0
  product = "redis"
}

locals {
  # Build a map of zone name to zone id
  zone_id_map = length(var.redis.replica_zone_names) > 0 ? {
    for zone in data.tencentcloud_availability_zones_by_product.az[0].zones :
    zone.name => zone.id
  } : {}

  # Convert zone names to zone IDs (use lookup with validation)
  replica_zone_ids = [
    for zone_name in var.redis.replica_zone_names :
    lookup(local.zone_id_map, zone_name, null)
  ]

  # Validate all zone names are valid
  invalid_zones = [
    for zone_name in var.redis.replica_zone_names :
    zone_name if !contains(keys(local.zone_id_map), zone_name)
  ]

  # Determine the effective password:
  # - no_auth=true: no password needed
  # - password provided: use provided password
  # - password not provided and no_auth=false: use generated random password
  effective_password = var.redis.no_auth ? null : (
    var.password != null && var.password != "" ? var.password : (
      length(random_password.secure_password) > 0 ? random_password.secure_password[0].result : null
    )
  )
}

# Create a multi-AZ redis instance
resource "tencentcloud_redis_instance" "redis_instance" {
  name              = var.redis.name
  availability_zone = var.redis.availability_zone
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id

  port = var.redis.port > 0 ? var.redis.port : 6379

  type_id            = var.redis.type_id
  charge_type        = var.redis.charge_type
  auto_renew_flag    = var.redis.charge_type == "PREPAID" ? var.redis.auto_renew_flag : 0
  prepaid_period     = var.redis.charge_type == "PREPAID" ? var.redis.prepaid_period : null
  no_auth            = var.redis.no_auth
  password           = local.effective_password
  mem_size           = var.redis.mem_size
  redis_shard_num    = var.redis.shard_num
  redis_replicas_num = var.redis.replicas_num
  replica_zone_ids   = length(local.replica_zone_ids) > 0 && length(local.invalid_zones) == 0 ? local.replica_zone_ids : null
  replicas_read_only = var.redis.replicas_read_only
  force_delete       = var.redis.force_delete

  security_groups = length(var.redis.security_groups) > 0 ? var.redis.security_groups : null
  tags            = var.tags

  lifecycle {
    precondition {
      condition     = length(local.invalid_zones) == 0
      error_message = "Invalid replica_zone_names: ${join(", ", local.invalid_zones)}. Available zones: ${join(", ", keys(local.zone_id_map))}"
    }
  }
}

# Generate a random password for the Redis instance if not provided and no_auth is false
resource "random_password" "secure_password" {
  count = var.redis.no_auth == false && (var.password == null || var.password == "") ? 1 : 0

  length  = var.redis.password_length
  special = true
  upper   = true
  lower   = true
  numeric = true

  keepers = var.password_rotation_months > 0 ? {
    rotation_trigger = time_rotating.rotation[0].id
  } : {}
}

resource "time_rotating" "rotation" {
  count = var.redis.no_auth == false && (var.password == null || var.password == "") && var.password_rotation_months > 0 ? 1 : 0

  rotation_months = var.password_rotation_months
}

# SSL configuration
resource "tencentcloud_redis_ssl" "redis_ssl_config" {
  count       = var.redis.ssl_enabled ? 1 : 0
  instance_id = tencentcloud_redis_instance.redis_instance.id
  ssl_config  = "enabled"
}

# Backup configuration
resource "tencentcloud_redis_backup_config" "backup" {
  count       = var.backup_strategy != null ? 1 : 0
  redis_id    = tencentcloud_redis_instance.redis_instance.id
  backup_time = var.backup_strategy.backup_time
}

resource "tencentcloud_redis_backup_operation" "example" {
  count        = var.storage_strategy != null ? 1 : 0
  instance_id  = tencentcloud_redis_instance.redis_instance.id
  storage_days = var.storage_strategy.storage_days
  remark       = var.storage_strategy.remark
}

# Create secret storing Redis credentials
resource "tencentcloud_ssm_secret" "redis_creds" {
  count = var.store_credentials_in_ssm && var.redis.no_auth == false ? 1 : 0

  secret_name = "${var.redis.name}-secret"
  description = "Redis credentials for ${var.redis.name}"
  tags        = var.tags

  depends_on = [tencentcloud_redis_instance.redis_instance]
}

resource "tencentcloud_ssm_secret_version" "v1" {
  count       = var.store_credentials_in_ssm && var.redis.no_auth == false ? 1 : 0
  secret_name = tencentcloud_ssm_secret.redis_creds[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    host     = tencentcloud_redis_instance.redis_instance.ip
    port     = tencentcloud_redis_instance.redis_instance.port
    password = local.effective_password
  })
}
