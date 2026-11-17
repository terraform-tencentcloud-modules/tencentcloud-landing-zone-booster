################################################################################
### MongoDB standby instance
################################################################################
resource "tencentcloud_mongodb_standby_instance" "instance" {
  instance_name          = var.mongodb_standby.name
  security_groups        = var.mongodb_standby.security_group_ids
  vpc_id                 = var.mongodb_standby.vpc_id
  subnet_id              = var.mongodb_standby.subnet_id
  available_zone         = var.mongodb_standby.available_zone
  cpu                    = var.mongodb_standby.cpu
  memory                 = var.mongodb_standby.memory
  volume                 = var.mongodb_standby.volume
  father_instance_id     = var.mongodb_standby.father_instance_id
  father_instance_region = var.mongodb_standby.father_instance_region
  project_id             = var.mongodb_standby.project_id
  in_maintenance         = var.mongodb_standby.in_maintenance
  data_encryption        = var.mongodb_standby.data_encryption
  encryption_key_source  = var.mongodb_standby.encryption_key_source
  kms_region             = var.mongodb_standby.kms_region
  key_id                 = var.mongodb_standby.kms_key_id
  charge_type            = var.mongodb_standby.charge_type
  auto_renew_flag        = var.mongodb_standby.charge_type == "PREPAID" ? var.mongodb_standby.auto_renew_flag : null
  prepaid_period         = var.mongodb_standby.charge_type == "PREPAID" ? var.mongodb_standby.prepaid_period : null

  tags = var.tags
}

# MongoDB SSL
resource "tencentcloud_mongodb_instance_ssl" "ssl" {
  count = var.mongodb_standby.enable_ssl ? 1 : 0

  instance_id = tencentcloud_mongodb_standby_instance.instance.id
  enable      = var.mongodb_standby.enable_ssl
}

# MongoDB transparent data encryption
resource "tencentcloud_mongodb_instance_transparent_data_encryption" "encryption" {
  count = var.mongodb_standby.enable_encryption ? 1 : 0

  instance_id = tencentcloud_mongodb_standby_instance.instance.id
  kms_region  = var.mongodb_standby.kms_region
  key_id      = var.mongodb_standby.kms_key_id
}

# MongoDB Backup Rule
resource "tencentcloud_mongodb_instance_backup_rule" "backup" {
  count = var.backup.enabled ? 1 : 0

  instance_id             = tencentcloud_mongodb_standby_instance.instance.id
  backup_method           = var.backup.backup_method
  backup_time             = var.backup.backup_time
  backup_retention_period = var.backup.backup_retention_period
  backup_version          = var.backup.backup_version
  backup_frequency        = var.backup.backup_frequency
}

# Create a MongoDB user
resource "tencentcloud_mongodb_instance_account" "account" {
  count = local.create_user ? 1 : 0

  instance_id         = tencentcloud_mongodb_standby_instance.instance.id
  user_name           = var.mongodb_standby.user_name
  password            = local.user_password
  mongo_user_password = local.system_user_password
  user_desc           = var.mongodb_standby.user_desc
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
  create_user                 = var.mongodb_standby.user_name != null && var.mongodb_standby.user_name != ""
  user_password               = local.create_user ? (local.use_generated_user_password ? random_password.user_password[0].result : var.user_password) : null
}

# Auto-generate system user (root) password
resource "random_password" "system_password" {
  count = local.use_generated_system_password ? 1 : 0

  length  = var.mongodb_standby.password_length
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# Auto-generate application user password
resource "random_password" "user_password" {
  count = local.create_user && local.use_generated_user_password ? 1 : 0

  length  = var.mongodb_standby.password_length
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# Create secret storing mongodb credentials
resource "tencentcloud_ssm_secret" "mongodb_creds" {
  count = var.store_credentials_in_ssm ? 1 : 0

  secret_name = "${var.mongodb_standby.name}-admin-mongodb-secret"
  description = "Mongodb system user credentials for ${var.mongodb_standby.name}"
  tags        = var.tags
  depends_on  = [tencentcloud_mongodb_standby_instance.instance]
}

resource "tencentcloud_ssm_secret_version" "v1" {
  count = var.store_credentials_in_ssm ? 1 : 0

  secret_name = tencentcloud_ssm_secret.mongodb_creds[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    username = "root"
    password = local.system_user_password
    port     = 27017
    host     = tencentcloud_mongodb_standby_instance.instance.vip
  })
}

# Create secret storing mongodb credentials
resource "tencentcloud_ssm_secret" "mongodb_user_creds" {
  count = var.store_credentials_in_ssm && local.create_user ? 1 : 0

  secret_name = "${var.mongodb_standby.name}-user-mongodb-secret"
  description = "Mongodb user credentials for ${var.mongodb_standby.name}"
  tags        = var.tags
  depends_on  = [tencentcloud_mongodb_standby_instance.instance]
}

resource "tencentcloud_ssm_secret_version" "v2" {
  count = var.store_credentials_in_ssm && local.create_user ? 1 : 0

  secret_name = tencentcloud_ssm_secret.mongodb_user_creds[0].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    username = var.mongodb_standby.user_name
    password = local.user_password
    port     = 27017
    host     = tencentcloud_mongodb_standby_instance.instance.vip
  })
}
