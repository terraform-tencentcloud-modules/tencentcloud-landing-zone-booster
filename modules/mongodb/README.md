# MongoDB Terraform Module

This module provisions a **Tencent Cloud MongoDB instance** (`tencentcloud_mongodb_instance`) with optional supporting resources managed through a single `mongodb_instance` configuration object.

Key capabilities:

- **Instance provisioning** — single replica set with multi-AZ nodes, configurable specs and billing.
- **SSL** — optional, controlled by `mongodb_instance.enable_ssl`.
- **Transparent Data Encryption (TDE)** — optional, controlled by `mongodb_instance.enable_encryption` (requires `kms_region` / `kms_key_id`).
- **Backup rule** — optional, controlled by `backup.enabled` (method, time, retention, frequency).
- **Account** — optional MongoDB user account, created when `mongodb_instance.user_name` is set, with configurable `auth_roles`.
- **Password management** — system (`root`) and application user passwords can be auto-generated (`random_password`) or provided via variables. Optional rotation via `time_rotating` when `password_rotation_months > 0`.
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
| `tencentcloud_mongodb_instance.instance` | resource |
| `tencentcloud_mongodb_instance_ssl.ssl` | resource (count = 1 when `enable_ssl`) |
| `tencentcloud_mongodb_instance_transparent_data_encryption.encryption` | resource (count = 1 when `enable_encryption`) |
| `tencentcloud_mongodb_instance_backup_rule.backup` | resource (count = 1 when `backup.enabled`) |
| `tencentcloud_mongodb_instance_account.account` | resource (count = 1 when `user_name` set) |
| `random_password.system_password` | resource (auto-generated root password) |
| `random_password.user_password` | resource (auto-generated user password) |
| `time_rotating.rotation` | resource (password rotation timer) |
| `tencentcloud_ssm_secret.mongodb_creds` | resource (admin secret) |
| `tencentcloud_ssm_secret.mongodb_user_creds` | resource (user secret) |
| `tencentcloud_cam_service_linked_role.role` | resource (KMS linked role, count = 1 when `create_kms_strategy`) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_mongodb_instance"></a> [mongodb\_instance](#input\_mongodb\_instance) | `object` | yes | – | MongoDB instance configuration. See structure below. |
| <a name="input_backup"></a> [backup](#input\_backup) | `object` | no | enabled `true`, method `1`, time `2`, retention `7`, version `1`, frequency `24` | MongoDB instance backup rule configuration. |
| <a name="input_auth_roles"></a> [auth\_roles](#input\_auth\_roles) | `list(object)` | no | `[{}]` | Account permission info. Each item: `mask` (default `3`), `namespace` (default `"*"`). |
| <a name="input_system_user_password"></a> [system\_user\_password](#input\_system\_user\_password) | `string` (sensitive) | no | `""` | Root account password. Leave empty to auto-generate. |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | `string` (sensitive) | no | `""` | Application user password. Leave empty to auto-generate. |
| <a name="input_store_credentials_in_ssm"></a> [store\_credentials\_in\_ssm](#input\_store\_credentials\_in\_ssm) | `bool` | no | `true` | Whether to store credentials in SSM. |
| <a name="input_create_kms_strategy"></a> [create\_kms\_strategy](#input\_create\_kms\_strategy) | `bool` | no | `false` | Whether to create the MongoDB KMS service-linked role. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags for the MongoDB instance. |

### `mongodb_instance` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Instance name (also used for secret naming). |
| `available_zone` | `string` | yes | – | Availability zone of the instance, e.g. `ap-singapore-2`. |
| `memory` | `number` | no | `4` | Memory size in GB. |
| `volume` | `number` | no | `100` | Storage capacity in GB. |
| `machine_type` | `string` | no | `"HIO10G"` | Instance type. `HIO` or `HIO10G`. |
| `engine_version` | `string` | no | `"MONGO_50_WT"` | MongoDB version. e.g. `MONGO_50_WT` (5.0), `MONGO_40_WT` (4.0). |
| `auto_renew_flag` | `number` | no | `0` | Auto renew flag: `0` (notify & manual), `1` (notify & auto), `2` (disable notify & manual). Only for PREPAID. |
| `availability_zone_list` | `list(string)` | yes | – | List of AZs where nodes are deployed. |
| `hidden_zone` | `string` | no | – | AZ to which the Hidden node belongs. |
| `node_num` | `number` | no | `3` | Number of nodes per replica set (min 3). |
| `vpc_id` | `string` | yes | – | VPC ID. |
| `subnet_id` | `string` | yes | – | Subnet ID. |
| `charge_type` | `string` | no | `"POSTPAID_BY_HOUR"` | Billing mode. `POSTPAID_BY_HOUR` or `PREPAID`. |
| `prepaid_period` | `number` | no | `1` | Prepaid tenancy in months. Valid: 1–12, 24, 36. Only for PREPAID. |
| `user_name` | `string` | no | – | New account name. Account created only when set. |
| `user_desc` | `string` | no | `""` | New user account remarks. |
| `enable_ssl` | `bool` | no | `false` | Whether to enable SSL. |
| `enable_encryption` | `bool` | no | `false` | Whether to enable transparent data encryption. |
| `kms_region` | `string` | no | – | KMS region, e.g. `ap-shanghai`. |
| `kms_key_id` | `string` | no | – | KMS key ID. If empty, Tencent Cloud auto-generates a key (not managed by Terraform). |
| `security_group_ids` | `list(string)` | no | `[]` | Security group IDs attached to the instance. |
| `password_length` | `number` | no | `32` | Length of auto-generated passwords. |
| `password_rotation_months` | `number` | no | `0` | Password rotation period in months. `0` disables rotation. |

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
| <a name="output_mongodb_instance_id"></a> [mongodb\_instance\_id](#output\_mongodb\_instance\_id) | ID of the MongoDB instance. |
| <a name="output_mongodb_vip"></a> [mongodb\_vip](#output\_mongodb\_vip) | VIP of the MongoDB instance. |
| <a name="output_mongodb_port"></a> [mongodb\_port](#output\_mongodb\_port) | Port of the MongoDB instance. |
| <a name="output_admin_secret_name"></a> [admin\_secret\_name](#output\_admin\_secret\_name) | Name of the SSM secret for admin credentials (null when `store_credentials_in_ssm` is false). |
| <a name="output_user_secret_name"></a> [user\_secret\_name](#output\_user\_secret\_name) | Name of the SSM secret for user credentials (null when disabled or no user). |

## Usage

### Basic instance with auto-generated password and SSL

```hcl
module "mongodb" {
  source = "./modules/mongodb"

  tags = {
    env = "prod"
  }

  mongodb_instance = {
    name                   = "my-mongodb"
    available_zone         = "ap-singapore-2"
    memory                 = 4
    volume                 = 100
    machine_type           = "HIO10G"
    engine_version         = "MONGO_50_WT"
    availability_zone_list = ["ap-singapore-2", "ap-singapore-3"]
    node_num               = 3
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

### With application user, TDE encryption, password rotation and SSM storage

```hcl
module "mongodb" {
  source = "./modules/mongodb"

  create_kms_strategy      = true
  store_credentials_in_ssm = true

  mongodb_instance = {
    name                   = "my-mongodb-secure"
    available_zone         = "ap-shanghai-2"
    availability_zone_list = ["ap-shanghai-2", "ap-shanghai-3", "ap-shanghai-4"]
    memory                 = 8
    volume                 = 200
    node_num               = 3
    vpc_id                 = "vpc-xxxxxxxx"
    subnet_id              = "subnet-xxxxxxxx"
    charge_type            = "PREPAID"
    prepaid_period         = 12
    auto_renew_flag        = 1
    user_name              = "appuser"
    user_desc              = "Application read-write user"
    enable_ssl             = true
    enable_encryption      = true
    kms_region             = "ap-shanghai"
    kms_key_id             = "kms-key-xxxxxxxx"
    password_length        = 32
    password_rotation_months = 3
  }

  auth_roles = [
    {
      mask      = 3
      namespace = "appdb"
    }
  ]
}
```

> **Note**: When `password_rotation_months > 0` and a password is auto-generated, the `random_password` resource uses a `time_rotating` keeper so the password rotates automatically. Provided (non-empty) passwords are not rotated.
