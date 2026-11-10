# terraform-tencentcloud-cdb-postgres
Terraform module which creates a TencentCloud PostgreSQL (CDB for PostgreSQL) instance with optional SSL, TDE/KMS, backup plan, custom accounts, parameters, and credential storage in SSM.

> **Note:** The module creates a primary + standby (1 primary node + 1 standby node) PostgreSQL instance. A random root password is generated when `root_password` is empty. Custom database accounts can be created via `var.users`, with random passwords generated when not provided.

## Resources created

| Resource | Count | Notes |
|----------|-------|-------|
| `tencentcloud_postgresql_instance.master` | 1 | The PostgreSQL instance (primary + standby nodes). |
| `random_password.secure_password` | 0..1 | Root password, created only when `root_password` is empty. |
| `time_rotating.rotation` | 0..1 | Root password rotation trigger, when enabled. |
| `random_password.users` | 0..N | Per-user passwords, created when a user has no `password`. |
| `tencentcloud_postgresql_instance_ssl_config.ssl_config` | 0..1 | SSL config, created when `ssl_enable` is true. |
| `tencentcloud_ssm_secret.postgres_creds` | 0..1 | SSM secret for credentials, when `store_credentials_in_ssm` is true. |
| `tencentcloud_ssm_secret_version.v1` | 0..1 | SSM secret version with the credentials. |
| `tencentcloud_postgresql_parameters.postgresql_parameters` | 0..1 | Instance parameters, when `postgresql_parameters` is set. |
| `tencentcloud_postgresql_account.users` | 0..N | Custom database accounts, one per entry in `var.users`. |
| `tencentcloud_postgresql_backup_plan_config.plan_config` | 0..1 | Backup plan config, when `backup_plan` is set. |
| `tencentcloud_cam_service_linked_role.role` | 0..1 | PostgreSQL KMS service-linked role, when `create_kms_strategy` is true. |

## Usage

```hcl
module "postgres" {
  source = "../../../../tc-modules/modules/cdb-postgres"

  postgres_instance = {
    name                        = "boost-life-pg"
    availability_zone           = "ap-guangzhou-3"
    standby_availability_zone   = "ap-guangzhou-4"
    vpc_id                      = "vpc-xxxxxxxx"
    subnet_id                   = "subnet-xxxxxxxx"
    memory                      = 4      # GB
    storage                     = 100    # GB
    cpu                         = 4
    engine_version              = "14.19"
    db_kernel_version           = "v14.19_r1.38"
    charset                     = "UTF8"
    charge_type                 = "POSTPAID_BY_HOUR"
    security_groups             = ["sg-xxxxxxxx"]
    delete_protection           = true

    ssl_enable     = true
    need_support_tde = 0

    backup_plan = {
      backup_period                = ["mon", "wed", "fri"]
      backup_method                = "physical"
      min_backup_start_time        = "02:00:00"
      max_backup_start_time        = "03:00:00"
      base_backup_retention_period = 7
      log_backup_retention_period  = 7
    }
  }

  root_user     = "root"
  root_password = "" # leave empty to auto-generate
  root_password_rotation_months = 0

  store_credentials_in_ssm = true

  postgresql_parameters = [
    { name = "max_connections", value = "200" }
  ]

  users = {
    "app" = {
      password = ""   # leave empty to auto-generate
      type     = "normal"
    }
  }

  tags = {
    createdBy = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | >= 1.81.174 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `postgres_instance` | (Required) The postgres instance input variables. See object definition below. | `object` | n/a |
| `create_kms_strategy` | (Optional) Whether to create KMS strategy (service-linked role) for postgres to use KMS. | `bool` | `false` |
| `root_user` | (Optional) Instance root account name. Default `root`. | `string` | `"root"` |
| `root_password` | (Optional, sensitive) Instance root account password. Leave empty to auto-generate. | `string` | `""` |
| `root_password_rotation_months` | (Optional) Root password rotation interval in months. Set > 0 to enable rotation. | `number` | `0` |
| `store_credentials_in_ssm` | (Optional) Whether to store PostgreSQL credentials in SSM. | `bool` | `true` |
| `random_password_length` | (Optional) Length of generated user passwords. | `number` | `12` |
| `random_password_special` | (Optional) Whether generated passwords contain special characters. | `bool` | `true` |
| `random_password_min_special` | (Optional) Minimum number of special characters in generated passwords. | `number` | `1` |
| `random_password_min_upper` | (Optional) Minimum number of uppercase characters in generated passwords. | `number` | `1` |
| `random_password_min_lower` | (Optional) Minimum number of lowercase characters in generated passwords. | `number` | `1` |
| `random_password_min_numeric` | (Optional) Minimum number of numeric characters in generated passwords. | `number` | `1` |
| `postgresql_parameters` | (Optional) PostgreSQL parameters list. | `list(object({ name = string, value = string }))` | `null` |
| `users` | (Optional) Custom database users. Password auto-generated if not provided. | `map(object({ password = optional(string), type = optional(string) }))` | `{}` |
| `tags` | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` |

### `postgres_instance` object

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name` | (Required) Instance name. | `string` | n/a |
| `availability_zone` | (Required) The availability zone of the instance. | `string` | n/a |
| `vpc_id` | (Required) VPC ID. | `string` | n/a |
| `subnet_id` | (Required) Subnet ID. | `string` | n/a |
| `memory` | (Required) Memory size in GB. | `number` | n/a |
| `storage` | (Required) Storage capacity in GB. | `number` | n/a |
| `cpu` | (Optional) Number of CPU cores. | `number` | `4` |
| `db_kernel_version` | (Optional) Database kernel version, e.g. `v11.12_r1.3`. | `string` | `"v14.19_r1.38"` |
| `engine_version` | (Optional) Database version, e.g. `13.3`. | `string` | `"14.19"` |
| `standby_availability_zone` | (Optional) The standby availability zone of the instance. | `string` | `null` |
| `readonly_enable` | (Optional) Whether to enable the standby instance. | `bool` | `false` |
| `charge_type` | (Optional) Billing mode: `POSTPAID_BY_HOUR` / `PREPAID`. | `string` | `"POSTPAID_BY_HOUR"` |
| `period` | (Optional) Prepaid period in months (1-12, 24, 36). | `number` | `null` |
| `auto_renew_flag` | (Optional) Auto renew flag: 0 no, 1 yes. | `number` | `0` |
| `auto_voucher` | (Optional) Whether to use voucher: 0 no, 1 yes. | `number` | `0` |
| `delete_protection` | (Optional) Whether to enable deletion protection. | `bool` | `true` |
| `max_standby_archive_delay` | (Optional) Max standby archive delay (ms if not specified). | `number` | `null` |
| `max_standby_streaming_delay` | (Optional) Max standby streaming delay (ms if not specified). | `number` | `null` |
| `charset` | (Optional) Database character set. | `string` | `"UTF8"` |
| `security_groups` | (Optional) Security group ID set. | `set(string)` | `null` |
| `project_id` | (Optional) Project ID. | `number` | `0` |
| `backup_plan` | (Optional) Backup plan config object. See below. | `object` | `null` |
| `need_support_tde` | (Optional) Whether to enable TDE. | `number` | `0` |
| `kms_key_id` | (Optional) KMS key ID. | `string` | `null` |
| `kms_region` | (Optional) KMS key region. | `string` | `null` |
| `ssl_enable` | (Optional) Whether to enable SSL. | `bool` | `false` |
| `password_length` | (Optional) Root password length (default 32). | `number` | `32` |

### `postgres_instance.backup_plan` object

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `backup_period` | (Optional) Backup cycle (lowercase weekday names). | `set(string)` | `null` |
| `backup_method` | (Optional) `physical`, `logical`, or `snapshot`. | `string` | `null` |
| `min_backup_start_time` | (Optional) Earliest backup start time, `hh:mm:ss`. | `string` | `null` |
| `max_backup_start_time` | (Optional) Latest backup start time, `hh:mm:ss`. | `string` | `null` |
| `base_backup_retention_period` | (Optional) Data backup retention (days), [0, 30000). | `number` | `null` |
| `log_backup_retention_period` | (Optional) Log backup retention (days), 7-1830. | `number` | `null` |

## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | The ID of the PostgreSQL master instance. |
| `private_ip_address` | The private IP of the PostgreSQL master instance. |
| `private_port` | The private port of the PostgreSQL master instance. |

## Authors

Maintained by the Boost Life migration / Landing Zone team.

## License

Mozilla Public License Version 2.0.
