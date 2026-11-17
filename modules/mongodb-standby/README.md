# MongoDB Standby Terraform Module

This module provisions a **Tencent Cloud MongoDB standby (read-only disaster recovery) instance** (`tencentcloud_mongodb_standby_instance`) — a read-only replica that replicates from an existing primary MongoDB instance in another region or zone. Its `engine_version` and `machine_type` are inherited from, and must match, the primary instance.

Key capabilities:

- **Standby (DR) provisioning** — references a primary instance via `father_instance_id` / `father_instance_region`, with its own specs (`memory`, `volume`, `cpu`), VPC/subnet and a distinct `available_zone` (must differ from the primary's zone).
- **SSL** — optional, controlled by `mongodb_standby.enable_ssl`.
- **Transparent Data Encryption (TDE)** — optional, controlled by `mongodb_standby.data_encryption` (immutable; requires `kms_region` / `kms_key_id` / `encryption_key_source`).
- **Backup rule** — optional, controlled by `backup.enabled` (method, time, retention, frequency).
- **Account** — optional MongoDB user account, created when `mongodb_standby.user_name` is set, with configurable `auth_roles`. The standby password is inherited from the primary instance.
- **Password management** — system (`root`) and application user passwords can be auto-generated (`random_password`) or provided via variables, then stored in SSM. (The standby instance itself does not accept a password; it inherits the primary's.)
- **SSM secrets** — optionally stores admin and user credentials in Tencent Cloud SSM (`tencentcloud_ssm_secret`), controlled by `store_credentials_in_ssm`.
- **KMS service-linked role** — optionally creates the MongoDB KMS linked role (`tencentcloud_cam_service_linked_role`), controlled by `create_kms_strategy`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| tencentcloud | >= 1.81.0 |
| random | >= 3.0 |
| time | >= 0.9 |

## Providers

| Provider | Source |
|----------|--------|
| tencentcloud | tencentcloudstack/tencentcloud |
| random | hashicorp/random |
| time | hashicorp/time |

## Resources

| Name | Type |
|------|------|
| `tencentcloud_mongodb_standby_instance.instance` | resource |
| `tencentcloud_mongodb_instance_ssl.ssl` | resource (count = 1 when `enable_ssl`) |
| `tencentcloud_mongodb_instance_transparent_data_encryption.encryption` | resource (count = 1 when `enable_encryption`) |
| `tencentcloud_mongodb_instance_backup_rule.backup` | resource (count = 1 when `backup.enabled`) |
| `tencentcloud_mongodb_instance_account.account` | resource (count = 1 when `user_name` set) |
| `random_password.system_password` | resource (auto-generated root password) |
| `random_password.user_password` | resource (auto-generated user password) |
| `tencentcloud_ssm_secret.mongodb_creds` | resource (admin secret) |
| `tencentcloud_ssm_secret.mongodb_user_creds` | resource (user secret) |
| `tencentcloud_cam_service_linked_role.role` | resource (KMS linked role, count = 1 when `create_kms_strategy`) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_mongodb_standby"></a> [mongodb\_standby](#input\_mongodb\_standby) | `object` | yes | – | MongoDB standby instance configuration. See structure below. |
| <a name="input_backup"></a> [backup](#input\_backup) | `object` | no | enabled `true`, method `1`, time `2`, retention `7`, version `1`, frequency `24` | MongoDB instance backup rule configuration. |
| <a name="input_auth_roles"></a> [auth\_roles](#input\_auth\_roles) | `list(object)` | no | `[{}]` | Account permission info. Each item: `mask` (default `3`), `namespace` (default `"*"`). |
| <a name="input_system_user_password"></a> [system\_user\_password](#input\_system\_user\_password) | `string` (sensitive) | no | `""` | Root account password (inherited from primary). Leave empty to auto-generate for SSM storage. |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | `string` (sensitive) | no | `""` | Application user password. Leave empty to auto-generate. |
| <a name="input_store_credentials_in_ssm"></a> [store\_credentials\_in\_ssm](#input\_store\_credentials\_in\_ssm) | `bool` | no | `true` | Whether to store credentials in SSM. |
| <a name="input_create_kms_strategy"></a> [create\_kms\_strategy](#input\_create\_kms\_strategy) | `bool` | no | `false` | Whether to create the MongoDB KMS service-linked role. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags for the MongoDB instance. |

### `mongodb_standby` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Instance name (`instance_name`). Also used for secret naming. |
| `father_instance_id` | `string` | yes | – | The ID of the primary instance this standby replicates from. ForceNew. |
| `father_instance_region` | `string` | yes | – | The region of the primary instance. ForceNew. |
| `available_zone` | `string` | yes | – | The availability zone of the standby instance. Required. ForceNew. NOTE: must NOT be the same as the primary instance's zone. |
| `cpu` | `number` | no | – | CPU core count of the standby instance. When empty, the default spec is used. Optional/Computed. |
| `memory` | `number` | yes | – | Memory size in GB (minimum 2). Memory and volume must be scaled together. |
| `volume` | `number` | yes | – | Storage capacity in GB (minimum 25). Memory and volume must be scaled together. |
| `vpc_id` | `string` | no | `""` | VPC ID. Must be set together with `subnet_id`. ForceNew. |
| `subnet_id` | `string` | no | – | Subnet ID. Must be set together with `vpc_id`. ForceNew. |
| `charge_type` | `string` | no | `"POSTPAID_BY_HOUR"` | Billing mode. `POSTPAID_BY_HOUR` or `PREPAID`. ForceNew. |
| `prepaid_period` | `number` | no | `1` | Prepaid tenancy in months. Valid: 1–12, 24, 36. Only for PREPAID. |
| `project_id` | `number` | no | `0` | ID of the project which the instance belongs to. |
| `auto_renew_flag` | `number` | no | `0` | Auto renew flag: `0` (notify & manual), `1` (notify & auto), `2` (disable notify & manual). Only for PREPAID. |
| `in_maintenance` | `number` | no | – | Switch time for config changes. `0`: immediately (default); `1`: within maintenance window. Node/volume changes do not support the window. |
| `security_group_ids` | `list(string)` | no | `[]` | Security group IDs attached to the instance. |
| `data_encryption` | `string` | no | – | Storage encryption mode on the instance at creation: `"TDE"` or `"No_Encryption"`. Immutable. |
| `encryption_key_source` | `string` | no | – | KMS key source when TDE is selected: `"auto"` or `"manual"`. Immutable. |
| `kms_region` | `string` | no | – | KMS region, e.g. `ap-shanghai`. |
| `kms_key_id` | `string` | no | – | KMS key ID (CMK alias). If empty and manual source, Tencent Cloud auto-generates a key (not managed by Terraform). |
| `user_name` | `string` | no | – | New account name. Account created only when set. |
| `user_desc` | `string` | no | `""` | New user account remarks. |
| `enable_ssl` | `bool` | no | `false` | Whether to enable SSL. |
| `enable_encryption` | `bool` | no | `false` | Whether to enable transparent data encryption (via the dedicated TDE resource). |
| `password_length` | `number` | no | `32` | Length of auto-generated passwords (used for SSM storage; the standby password is inherited from the primary instance). |

### `backup` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `enabled` | `bool` | no | `true` | Whether to enable the backup rule. |
| `backup_method` | `number` | no | `1` | `0` (logical), `1` (physical), `3` (snapshot). |
| `backup_time` | `number` | no | `2` | Auto backup start hour, range `[0,23]`. |
| `backup_retention_period` | `number` | no | `7` | Retention period in days, range `[7,365]`. |
| `backup_version` | `number` | no | `1` | `0` (old), `1` (advanced). |
| `backup_frequency` | `number` | no | `24` | `12` (twice daily), `24` (once daily). |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mongodb_instance_id"></a> [mongodb\_instance\_id](#output\_mongodb\_instance\_id) | ID of the MongoDB standby instance. |
| <a name="output_mongodb_vip"></a> [mongodb\_vip](#output\_mongodb\_vip) | VIP of the MongoDB standby instance. |
| <a name="output_mongodb_port"></a> [mongodb\_port](#output\_mongodb\_port) | Port of the MongoDB standby instance. |
| <a name="output_admin_secret_name"></a> [admin\_secret\_name](#output\_admin\_secret\_name) | Name of the SSM secret for admin credentials (null when `store_credentials_in_ssm` is false). |
| <a name="output_user_secret_name"></a> [user\_secret\_name](#output\_user\_secret\_name) | Name of the SSM secret for user credentials (null when disabled or no user). |

## Usage

### Basic standby instance replicating from a primary

```hcl
module "mongodb_standby" {
  source = "./modules/mongodb-standby"

  tags = {
    env = "prod"
  }

  mongodb_standby = {
    name                   = "my-mongodb-standby"
    father_instance_id     = "cmgo-xxxxxxxx"
    father_instance_region = "ap-guangzhou"
    available_zone         = "ap-guangzhou-7"
    memory                 = 4
    volume                 = 100
    vpc_id                 = "vpc-xxxxxxxx"
    subnet_id              = "subnet-xxxxxxxx"
    charge_type            = "POSTPAID_BY_HOUR"
    enable_ssl             = true
    password_length        = 32
  }

  backup = {
    enabled                 = true
    backup_method           = 1
    backup_time             = 2
    backup_retention_period = 7
    backup_version          = 1
    backup_frequency        = 24
  }
}
```

### With application user, TDE encryption and SSM storage

```hcl
module "mongodb_standby" {
  source = "./modules/mongodb-standby"

  create_kms_strategy      = true
  store_credentials_in_ssm = true

  mongodb_standby = {
    name                   = "my-mongodb-standby-secure"
    father_instance_id     = "cmgo-xxxxxxxx"
    father_instance_region = "ap-shanghai"
    available_zone         = "ap-shanghai-5"
    memory                 = 8
    volume                 = 200
    vpc_id                 = "vpc-xxxxxxxx"
    subnet_id              = "subnet-xxxxxxxx"
    charge_type            = "PREPAID"
    prepaid_period         = 12
    auto_renew_flag        = 1
    project_id             = 0
    data_encryption        = "TDE"
    encryption_key_source  = "kms"
    kms_region             = "ap-shanghai"
    kms_key_id             = "kms-key-xxxxxxxx"
    user_name              = "appuser"
    user_desc              = "Application read-only user"
    enable_ssl             = true
    password_length        = 32
  }

  auth_roles = [
    {
      mask      = 1
      namespace = "appdb"
    }
  ]
}
```

> **Note**: A standby instance inherits its `engine_version` and `machine_type` from the primary instance and does not accept a `password` of its own — it uses the primary's account password. The `available_zone` must not be the same as the primary instance's zone.
