# MongoDB Readonly Terraform Module

This module provisions a **Tencent Cloud MongoDB readonly (read-only replica) instance** (`tencentcloud_mongodb_readonly_instance`) — a read-only node that replicates from an existing primary MongoDB instance. It supports either a `REPLSET` (replica set) or `SHARD` (sharded) cluster topology via `cluster_type`. Its `engine_version` and `machine_type` are inherited from, and must match, the primary instance.

Key capabilities:

- **Readonly provisioning** — references a primary instance via `father_instance_id` / `father_instance_region`, with its own specs (`memory`, `volume`, `cpu`), VPC/subnet and `available_zone`.
- **Cluster topology** — `cluster_type` selects `REPLSET` (single replica set) or `SHARD` (sharded cluster). For `SHARD`, additional shard/mongos settings (`shard_quantity`, `nodes_per_shard`, `mongos_cpu`, `mongos_memory`, `mongos_node_num`) apply.
- **SSL** — optional, controlled by `mongodb_readonly.enable_ssl`.
- **Transparent Data Encryption (TDE)** — optional, controlled by `mongodb_readonly.data_encryption` (immutable; requires `kms_region` / `kms_key_id` / `encryption_key_source`).
- **Backup rule** — optional, controlled by `backup.enabled` (method, time, retention, frequency).
- **Account** — optional MongoDB user account, created when `mongodb_readonly.user_name` is set, with configurable `auth_roles`. The readonly password is inherited from the primary instance.
- **Password management** — system (`root`) and application user passwords can be auto-generated (`random_password`) or provided via variables, then stored in SSM. (The readonly instance itself does not accept a password; it inherits the primary's.)
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
| `tencentcloud_mongodb_readonly_instance.instance` | resource |
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
| <a name="input_mongodb_readonly"></a> [mongodb\_readonly](#input\_mongodb\_readonly) | `object` | yes | – | MongoDB readonly instance configuration. See structure below. |
| <a name="input_backup"></a> [backup](#input\_backup) | `object` | no | enabled `true`, method `1`, time `2`, retention `7`, version `1`, frequency `24` | MongoDB instance backup rule configuration. |
| <a name="input_auth_roles"></a> [auth\_roles](#input\_auth\_roles) | `list(object)` | no | `[{}]` | Account permission info. Each item: `mask` (default `3`), `namespace` (default `"*"`). |
| <a name="input_system_user_password"></a> [system\_user\_password](#input\_system\_user\_password) | `string` (sensitive) | no | `""` | Root account password (inherited from primary). Leave empty to auto-generate for SSM storage. |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | `string` (sensitive) | no | `""` | Application user password. Leave empty to auto-generate. |
| <a name="input_store_credentials_in_ssm"></a> [store\_credentials\_in\_ssm](#input\_store\_credentials\_in\_ssm) | `bool` | no | `true` | Whether to store credentials in SSM. |
| <a name="input_create_kms_strategy"></a> [create\_kms\_strategy](#input\_create\_kms\_strategy) | `bool` | no | `false` | Whether to create the MongoDB KMS service-linked role. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags for the MongoDB instance. |

### `mongodb_readonly` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Instance name (`instance_name`). Also used for secret naming. |
| `father_instance_id` | `string` | yes | – | The ID of the primary instance this readonly replicates from. ForceNew. |
| `father_instance_region` | `string` | yes | – | The region of the primary instance. ForceNew. |
| `cluster_type` | `string` | yes | – | Instance schema type: `REPLSET` (replica set) or `SHARD` (sharded). ForceNew. |
| `available_zone` | `string` | yes | – | The availability zone of the readonly instance. |
| `cpu` | `number` | no | – | CPU core count of the readonly instance. When empty, the default spec is used. Optional/Computed. |
| `memory` | `number` | yes | – | Memory size in GB (minimum 2). Memory and volume must be scaled together. |
| `volume` | `number` | yes | – | Storage capacity in GB (minimum 25). Memory and volume must be scaled together. |
| `engine_version` | `string` | yes | – | MongoDB version. Allowed: `MONGO_40_WT`, `MONGO_42_WT`, `MONGO_44_WT`, `MONGO_50_WT`, `MONGO_60_WT`, `MONGO_70_WT`, `MONGO_80_WT`, `MONGO_83_WT`. |
| `machine_type` | `string` | yes | – | Instance type. Allowed: `HIO` (or deprecated `GIO`), `HIO10G` (or deprecated `TGIO`). ForceNew. |
| `node_num` | `number` | no | `3` | Number of nodes in each replica set. Default 3. Optional/Computed. |
| `shard_quantity` | `number` | no | – | Number of shards, range `[2,20]`. Only for `SHARD`. ForceNew. |
| `nodes_per_shard` | `number` | no | – | Number of nodes per shard, range `[3,5]`. Only for `SHARD`. ForceNew. |
| `mongos_cpu` | `number` | no | – | Mongos CPU core count. Only for `SHARD`. Optional/Computed. |
| `mongos_memory` | `number` | no | – | Mongos memory size in GB. Only for `SHARD`. Optional/Computed. |
| `mongos_node_num` | `number` | no | – | Number of mongos nodes. Only for `SHARD`. Optional/Computed. |
| `vpc_id` | `string` | no | `""` | VPC ID. Must be set together with `subnet_id`. ForceNew. |
| `subnet_id` | `string` | no | – | Subnet ID. Must be set together with `vpc_id`. ForceNew. |
| `in_maintenance` | `number` | no | – | Switch time for instance config changes. `0`: immediately (default); `1`: within maintenance window. Note: node/shard count changes do not support the maintenance window. |
| `charge_type` | `string` | no | `"POSTPAID_BY_HOUR"` | Billing mode. `POSTPAID_BY_HOUR` or `PREPAID`. ForceNew. |
| `prepaid_period` | `number` | no | `1` | Prepaid tenancy in months. Valid: 1–12, 24, 36. Only for PREPAID. |
| `project_id` | `number` | no | `0` | ID of the project which the instance belongs to. |
| `auto_renew_flag` | `number` | no | `0` | Auto renew flag: `0` (notify & manual), `1` (notify & auto), `2` (disable notify & manual). Only for PREPAID. |
| `security_group_ids` | `list(string)` | no | `[]` | Security group IDs attached to the instance. |
| `data_encryption` | `string` | no | – | Transparent data encryption mode: `"TDE"` or `"No_Encryption"`. Immutable. |
| `encryption_key_source` | `string` | no | – | The source of the encryption key. Valid values: `"auto"`, `"manual"`. |
| `kms_region` | `string` | no | – | KMS region, e.g. `ap-shanghai`. |
| `kms_key_id` | `string` | no | – | KMS key ID (CMK alias). If empty, Tencent Cloud auto-generates a key (not managed by Terraform). |
| `user_name` | `string` | no | – | New account name. Account created only when set. |
| `user_desc` | `string` | no | `""` | New user account remarks. |
| `enable_ssl` | `bool` | no | `false` | Whether to enable SSL. |
| `password_length` | `number` | no | `32` | Length of auto-generated passwords (used for SSM storage). |

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
| <a name="output_mongodb_instance_id"></a> [mongodb\_instance\_id](#output\_mongodb\_instance\_id) | ID of the MongoDB readonly instance. |
| <a name="output_mongodb_vip"></a> [mongodb\_vip](#output\_mongodb\_vip) | VIP of the MongoDB readonly instance. |
| <a name="output_mongodb_port"></a> [mongodb\_port](#output\_mongodb\_port) | Port of the MongoDB readonly instance. |
| <a name="output_admin_secret_name"></a> [admin\_secret\_name](#output\_admin\_secret\_name) | Name of the SSM secret for admin credentials (null when `store_credentials_in_ssm` is false). |
| <a name="output_user_secret_name"></a> [user\_secret\_name](#output\_user\_secret\_name) | Name of the SSM secret for user credentials (null when disabled or no user). |

## Usage

### REPLSET (single replica set) readonly instance

```hcl
module "mongodb_readonly" {
  source = "./modules/mongodb-readonly"

  tags = {
    env = "prod"
  }

  mongodb_readonly = {
    name                   = "my-mongodb-readonly-replset"
    father_instance_id     = "cmgo-xxxxxxxx"
    father_instance_region = "ap-guangzhou"
    cluster_type           = "REPLSET"
    available_zone         = "ap-guangzhou-7"
    engine_version         = "MONGO_80_WT"
    machine_type           = "HIO"
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

### SHARD (sharded) readonly instance with mongos, TDE and SSM storage

```hcl
module "mongodb_readonly" {
  source = "./modules/mongodb-readonly"

  create_kms_strategy      = true
  store_credentials_in_ssm = true

  mongodb_readonly = {
    name                   = "my-mongodb-readonly-shard"
    father_instance_id     = "cmgo-xxxxxxxx"
    father_instance_region = "ap-shanghai"
    cluster_type           = "SHARD"
    available_zone         = "ap-shanghai-5"
    engine_version         = "MONGO_80_WT"
    machine_type           = "HIO"
    memory                 = 8
    volume                 = 200
    shard_quantity         = 2
    nodes_per_shard        = 3
    mongos_cpu             = 1
    mongos_memory          = 2
    mongos_node_num        = 3
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

> **Note**: A readonly instance inherits its engine version and machine type configuration from the primary instance and does not accept a `password` of its own — it uses the primary's account password. `engine_version` and `machine_type` are required inputs to match the primary instance's spec. Shard-related attributes (`shard_quantity`, `nodes_per_shard`, `mongos_*`) only take effect when `cluster_type` is set to `SHARD`.
