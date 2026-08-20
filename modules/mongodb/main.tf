################################################################################
### MongoDB instance
################################################################################
resource "tencentcloud_mongodb_instance" "instance" {
  instance_name          = var.mongodb_instance.name
  security_groups        = var.mongodb_instance.security_group_ids
  vpc_id                 = var.mongodb_instance.vpc_id
  subnet_id              = var.mongodb_instance.subnet_id
  available_zone         = var.mongodb_instance.available_zone
  memory                 = var.mongodb_instance.memory
  volume                 = var.mongodb_instance.volume
  engine_version         = var.mongodb_instance.engine_version
  machine_type           = var.mongodb_instance.machine_type
  availability_zone_list = var.mongodb_instance.availability_zone_list
  hidden_zone            = var.mongodb_instance.hidden_zone
  node_num               = var.mongodb_instance.node_num
  password               = local.system_user_password
  charge_type            = var.mongodb_instance.charge_type
  auto_renew_flag        = var.mongodb_instance.charge_type == "PREPAID" ? var.mongodb_instance.auto_renew_flag : null
  prepaid_period         = var.mongodb_instance.charge_type == "PREPAID" ? var.mongodb_instance.prepaid_period : null

  tags = var.tags
}

# MongoDB SSL
resource "tencentcloud_mongodb_instance_ssl" "ssl" {
  count = var.mongodb_instance.enable_ssl ? 1 : 0

  instance_id = tencentcloud_mongodb_instance.instance.id
  enable      = var.mongodb_instance.enable_ssl
}

# MongoDB transparent data encryption
resource "tencentcloud_mongodb_instance_transparent_data_encryption" "encryption" {
  count = var.mongodb_instance.enable_encryption ? 1 : 0

  instance_id = tencentcloud_mongodb_instance.instance.id
  kms_region  = var.mongodb_instance.kms_region
}

# MongoDB Backup Rule
resource "tencentcloud_mongodb_instance_backup_rule" "backup" {
  count = var.backup.enabled ? 1 : 0

  instance_id             = tencentcloud_mongodb_instance.instance.id
  backup_method           = var.backup.backup_method
  backup_time             = var.backup.backup_time
  backup_retention_period = var.backup.backup_retention_period
  backup_version          = var.backup.backup_version
  backup_frequency        = var.backup.backup_frequency
}

# Create a MongoDB user
resource "tencentcloud_mongodb_instance_account" "account" {
  count = local.create_user ? 1 : 0

  instance_id         = tencentcloud_mongodb_instance.instance.id
  user_name           = var.mongodb_instance.user_name
  password            = local.user_password
  mongo_user_password = local.system_user_password
  user_desc           = var.mongodb_instance.user_desc
  dynamic "auth_role" {
    for_each = var.auth_roles
    content {
      namespace = auth_role.value.namespace
      mask      = auth_role.value.mask
    }
  }
}
################################################################################
### Password Management
################################################################################
locals {
  # System user (root) password
  use_generated_system_password = var.system_user_password == null || var.system_user_password == ""
  enable_system_rotation        = local.use_generated_system_password && var.mongodb_instance.password_rotation_months > 0
  system_user_password          = local.use_generated_system_password ? random_password.system_password[0].result : var.system_user_password

  # Application user password
  use_generated_user_password = var.user_password == null || var.user_password == ""
  create_user                 = var.mongodb_instance.user_name != null && var.mongodb_instance.user_name != ""
  enable_user_rotation        = local.create_user && local.use_generated_user_password && var.mongodb_instance.password_rotation_months > 0
  user_password               = local.create_user ? (local.use_generated_user_password ? random_password.user_password[0].result : var.user_password) : null
}

# Password rotation timer (shared by both passwords)
resource "time_rotating" "rotation" {
  count = local.enable_system_rotation || local.enable_user_rotation ? 1 : 0

  rotation_months = var.mongodb_instance.password_rotation_months
}

# Auto-generate system user (root) password
resource "random_password" "system_password" {
  count = local.use_generated_system_password ? 1 : 0

  length  = var.mongodb_instance.password_length
  special = false
  upper   = true
  lower   = true
  numeric = true

  keepers = local.enable_system_rotation ? {
    rotation_trigger = time_rotating.rotation[0].id
  } : {}
}

# Auto-generate application user password
resource "random_password" "user_password" {
  count = local.create_user && local.use_generated_user_password ? 1 : 0

  length  = var.mongodb_instance.password_length
  special = false
  upper   = true
  lower   = true
  numeric = true

  keepers = local.enable_user_rotation ? {
    rotation_trigger = time_rotating.rotation[0].id
  } : {}
}

# Create secret storing mongodb credentials
resource "tencentcloud_ssm_secret" "mongodb_creds" {
  count = var.store_credentials_in_ssm ? 1 : 0

  secret_name = "${var.mongodb_instance.name}-admin-mongodb-secret"
  description = "Mongodb system user credentials for ${var.mongodb_instance.name}"
  tags        = var.tags
  depends_on  = [tencentcloud_mongodb_instance.instance]
}

resource "tencentcloud_ssm_secret_version" "v1" {
  count = var.store_credentials_in_ssm ? 1 : 0

  secret_name = tencentcloud_ssm_secret.mongodb_creds[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    username = "root"
    password = local.system_user_password
    port     = 27017
    host     = tencentcloud_mongodb_instance.instance.vip
  })
}

# Create secret storing mongodb credentials
resource "tencentcloud_ssm_secret" "mongodb_user_creds" {
  count = var.store_credentials_in_ssm && local.create_user ? 1 : 0

  secret_name = "${var.mongodb_instance.name}-user-mongodb-secret"
  description = "Mongodb user credentials for ${var.mongodb_instance.name}"
  tags        = var.tags
  depends_on  = [tencentcloud_mongodb_instance.instance]
}

resource "tencentcloud_ssm_secret_version" "v2" {
  count = var.store_credentials_in_ssm && local.create_user ? 1 : 0

  secret_name = tencentcloud_ssm_secret.mongodb_user_creds[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    username = var.mongodb_instance.user_name
    password = local.user_password
    port     = 27017
    host     = tencentcloud_mongodb_instance.instance.vip
  })
}
