################################################################################
### MongoDB readonly instance
################################################################################
resource "tencentcloud_mongodb_readonly_instance" "instance" {
  instance_name          = var.mongodb_readonly.name
  security_groups        = var.mongodb_readonly.security_group_ids
  vpc_id                 = var.mongodb_readonly.vpc_id
  subnet_id              = var.mongodb_readonly.subnet_id
  available_zone         = var.mongodb_readonly.available_zone
  cpu                    = var.mongodb_readonly.cpu
  memory                 = var.mongodb_readonly.memory
  volume                 = var.mongodb_readonly.volume
  engine_version         = var.mongodb_readonly.engine_version
  machine_type           = var.mongodb_readonly.machine_type
  node_num               = var.mongodb_readonly.node_num
  father_instance_id     = var.mongodb_readonly.father_instance_id
  father_instance_region = var.mongodb_readonly.father_instance_region
  cluster_type           = var.mongodb_readonly.cluster_type
  in_maintenance         = var.mongodb_readonly.in_maintenance
  project_id             = var.mongodb_readonly.project_id
  data_encryption        = var.mongodb_readonly.data_encryption
  encryption_key_source  = var.mongodb_readonly.encryption_key_source
  kms_region             = var.mongodb_readonly.kms_region
  key_id                 = var.mongodb_readonly.kms_key_id
  charge_type            = var.mongodb_readonly.charge_type
  auto_renew_flag        = var.mongodb_readonly.charge_type == "PREPAID" ? var.mongodb_readonly.auto_renew_flag : null
  prepaid_period         = var.mongodb_readonly.charge_type == "PREPAID" ? var.mongodb_readonly.prepaid_period : null

  # The following attributes only apply to SHARD clusters.
  shard_quantity  = var.mongodb_readonly.cluster_type == "SHARD" ? var.mongodb_readonly.shard_quantity : null
  nodes_per_shard = var.mongodb_readonly.cluster_type == "SHARD" ? var.mongodb_readonly.nodes_per_shard : null
  mongos_cpu      = var.mongodb_readonly.cluster_type == "SHARD" ? var.mongodb_readonly.mongos_cpu : null
  mongos_memory   = var.mongodb_readonly.cluster_type == "SHARD" ? var.mongodb_readonly.mongos_memory : null
  mongos_node_num = var.mongodb_readonly.cluster_type == "SHARD" ? var.mongodb_readonly.mongos_node_num : null

  tags = var.tags
}

# MongoDB SSL
resource "tencentcloud_mongodb_instance_ssl" "ssl" {
  count = var.mongodb_readonly.enable_ssl ? 1 : 0

  instance_id = tencentcloud_mongodb_readonly_instance.instance.id
  enable      = var.mongodb_readonly.enable_ssl
}

# MongoDB transparent data encryption
resource "tencentcloud_mongodb_instance_transparent_data_encryption" "encryption" {
  count = var.mongodb_readonly.enable_encryption ? 1 : 0

  instance_id = tencentcloud_mongodb_readonly_instance.instance.id
  kms_region  = var.mongodb_readonly.kms_region
  key_id      = var.mongodb_readonly.kms_key_id
}

# MongoDB Backup Rule
resource "tencentcloud_mongodb_instance_backup_rule" "backup" {
  count = var.backup.enabled ? 1 : 0

  instance_id             = tencentcloud_mongodb_readonly_instance.instance.id
  backup_method           = var.backup.backup_method
  backup_time             = var.backup.backup_time
  backup_retention_period = var.backup.backup_retention_period
  backup_version          = var.backup.backup_version
  backup_frequency        = var.backup.backup_frequency
}

# Create a MongoDB user
resource "tencentcloud_mongodb_instance_account" "account" {
  count = local.create_user ? 1 : 0

  instance_id         = tencentcloud_mongodb_readonly_instance.instance.id
  user_name           = var.mongodb_readonly.user_name
  password            = local.user_password
  mongo_user_password = local.system_user_password
  user_desc           = var.mongodb_readonly.user_desc
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
  # System user (root) password — inherited from the primary instance.
  use_generated_system_password = var.system_user_password == null || var.system_user_password == ""
  system_user_password          = local.use_generated_system_password ? random_password.system_password[0].result : var.system_user_password

  # Application user password
  use_generated_user_password = var.user_password == null || var.user_password == ""
  create_user                 = var.mongodb_readonly.user_name != null && var.mongodb_readonly.user_name != ""
  user_password               = local.create_user ? (local.use_generated_user_password ? random_password.user_password[0].result : var.user_password) : null
}

# Auto-generate system user (root) password
resource "random_password" "system_password" {
  count = local.use_generated_system_password ? 1 : 0

  length  = var.mongodb_readonly.password_length
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# Auto-generate application user password
resource "random_password" "user_password" {
  count = local.create_user && local.use_generated_user_password ? 1 : 0

  length  = var.mongodb_readonly.password_length
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# Create secret storing mongodb credentials
resource "tencentcloud_ssm_secret" "mongodb_creds" {
  count = var.store_credentials_in_ssm ? 1 : 0

  secret_name = "${var.mongodb_readonly.name}-admin-mongodb-secret"
  description = "Mongodb system user credentials for ${var.mongodb_readonly.name}"
  tags        = var.tags
  depends_on  = [tencentcloud_mongodb_readonly_instance.instance]
}

resource "tencentcloud_ssm_secret_version" "v1" {
  count = var.store_credentials_in_ssm ? 1 : 0

  secret_name = tencentcloud_ssm_secret.mongodb_creds[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    username = "root"
    password = local.system_user_password
    port     = 27017
    host     = tencentcloud_mongodb_readonly_instance.instance.vip
  })
}

# Create secret storing mongodb credentials
resource "tencentcloud_ssm_secret" "mongodb_user_creds" {
  count = var.store_credentials_in_ssm && local.create_user ? 1 : 0

  secret_name = "${var.mongodb_readonly.name}-user-mongodb-secret"
  description = "Mongodb user credentials for ${var.mongodb_readonly.name}"
  tags        = var.tags
  depends_on  = [tencentcloud_mongodb_readonly_instance.instance]
}

resource "tencentcloud_ssm_secret_version" "v2" {
  count = var.store_credentials_in_ssm && local.create_user ? 1 : 0

  secret_name = tencentcloud_ssm_secret.mongodb_user_creds[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    username = var.mongodb_readonly.user_name
    password = local.user_password
    port     = 27017
    host     = tencentcloud_mongodb_readonly_instance.instance.vip
  })
}
