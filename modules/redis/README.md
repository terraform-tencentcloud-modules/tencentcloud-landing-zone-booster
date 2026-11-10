# Redis Terraform Module

This module provisions a **Tencent Cloud Redis instance** (`tencentcloud_redis_instance`) with optional supporting resources.

Key capabilities:

- **Instance provisioning** — configurable architecture via `type_id` (standard / cluster), memory, shards, replicas, and billing.
- **Multi-AZ** — optional replica zone names (`redis.replica_zone_names`); zone names are resolved to zone IDs via a `tencentcloud_zones` data source and validated at plan time (a `lifecycle.precondition` fails the plan on invalid names).
- **Authentication** — password-based by default. Password can be provided (`password`), auto-generated (`random_password`), or disabled (`redis.no_auth`, private-cloud only).
- **Password rotation** — optional via `time_rotating` when `password_rotation_months > 0` (only applies to auto-generated passwords).
- **SSL** — optional, controlled by `redis.ssl_enabled`.
- **Backup** — optional, controlled by `backup_strategy` (backup time window).
- **Storage** — optional, controlled by `storage_strategy` (retention days).
- **SSM secrets** — optionally stores Redis credentials in Tencent Cloud SSM (`tencentcloud_ssm_secret`), controlled by `store_credentials_in_ssm`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | >= 1.18.1 |
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
| `tencentcloud_redis_instance.redis_instance` | resource |
| `random_password.secure_password` | resource (auto-generated password) |
| `time_rotating.rotation` | resource (password rotation timer) |
| `tencentcloud_redis_ssl.redis_ssl_config` | resource (count = 1 when `ssl_enabled`) |
| `tencentcloud_redis_backup_config.backup` | resource (count = 1 when `backup_strategy` set) |
| `tencentcloud_redis_backup_operation.example` | resource (count = 1 when `storage_strategy` set) |
| `tencentcloud_ssm_secret.redis_creds` | resource (credentials secret) |
| `data.tencentcloud_zones.az` | data source (zone resolution for replicas) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_redis"></a> [redis](#input\_redis) | `object` | yes | – | Redis instance configuration. See structure below. |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | `string` | yes | – | VPC ID the instance is associated with. |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | `string` | yes | – | Subnet the instance belongs to. |
| <a name="input_password"></a> [password](#input\_password) | `string` (sensitive) | no | `""` | Redis password (8–64 chars). Can only be empty when `no_auth=true`. |
| <a name="input_password_rotation_months"></a> [password\_rotation\_months](#input\_password\_rotation\_months) | `number` | no | `0` | Password rotation period in months. `0` disables rotation. |
| <a name="input_backup_strategy"></a> [backup\_strategy](#input\_backup\_strategy) | `object` | no | `null` | Backup config (`backup_time`). Set `null` to disable. |
| <a name="input_storage_strategy"></a> [storage\_strategy](#input\_storage\_strategy) | `object` | no | `null` | Storage config (`storage_days`, `remark`). Set `null` to disable. |
| <a name="input_store_credentials_in_ssm"></a> [store\_credentials\_in\_ssm](#input\_store\_credentials\_in\_ssm) | `bool` | no | `false` | Whether to store credentials in SSM. |
| <a name="input_zone_query_product"></a> [zone\_query\_product](#input\_zone\_query\_product) | `string` | no | `"redis"` | Product name used to query zones. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags for the Redis instance. |

### `redis` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Instance name. |
| `availability_zone` | `string` | yes | – | Primary availability zone. |
| `mem_size` | `number` | yes | – | Memory size (> 0, enforced by validation). |
| `type_id` | `number` | no | `15` | Instance type. `2/3/4/6/7/8/9/15/16/17/18` (standard/cluster, Redis 2.8–7.0). See comments in code. |
| `charge_type` | `string` | no | `"POSTPAID"` | `PREPAID` or `POSTPAID` (enforced by validation). |
| `auto_renew_flag` | `number` | no | `1` | `0` (manual), `1` (auto), `2` (not auto). Only for PREPAID. |
| `prepaid_period` | `number` | no | `1` | Prepaid tenancy in months. Only for PREPAID. |
| `port` | `number` | no | `6379` | Access port (defaults to 6379 when `<= 0`). |
| `shard_num` | `number` | no | – | Number of shards (cluster architecture only). |
| `replicas_num` | `number` | no | – | Number of replicas. |
| `replica_zone_names` | `list(string)` | no | `[]` | Replica node AZ names, e.g. `["ap-guangzhou-3", "ap-guangzhou-4"]`. |
| `replicas_read_only` | `bool` | no | `false` | Whether replica read-only is supported. |
| `security_groups` | `list(string)` | no | `[]` | Security group IDs. |
| `force_delete` | `bool` | no | `false` | Whether to delete the instance directly. |
| `ssl_enabled` | `bool` | no | `false` | Whether to enable SSL. |
| `no_auth` | `bool` | no | `false` | Whether to allow no-auth access (private cloud only; only then can password be empty). |
| `password_length` | `number` | no | `32` | Length of auto-generated password. |

### `backup_strategy` object

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `backup_time` | `string` | yes | Backup time window in format `HH:MM-HH:MM`, e.g. `04:00-05:00` (enforced by validation). |

### `storage_strategy` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `storage_days` | `number` | yes | – | Retention days. `0` = default retention (≥ 0, enforced by validation). |
| `remark` | `string` | no | – | Remark. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_redis_instance_id"></a> [redis\_instance\_id](#output\_redis\_instance\_id) | ID of the Redis instance. |
| <a name="output_redis_instance_ip"></a> [redis\_instance\_ip](#output\_redis\_instance\_ip) | IP address of the Redis instance. |
| <a name="output_redis_instance_port"></a> [redis\_instance\_port](#output\_redis\_instance\_port) | Port of the Redis instance. |

## Usage

### Basic postpaid instance with auto-generated password

```hcl
module "redis" {
  source = "./modules/redis"

  vpc_id    = "vpc-xxxxxxxx"
  subnet_id = "subnet-xxxxxxxx"

  tags = {
    env = "prod"
  }

  redis = {
    name              = "my-redis"
    availability_zone = "ap-guangzhou-3"
    mem_size          = 4
    type_id           = 15
    charge_type       = "POSTPAID"
    port              = 6379
    replicas_read_only = false
  }
}
```

### Cluster instance with multi-AZ replicas, SSL, backup, storage, and SSM secret

```hcl
module "redis" {
  source = "./modules/redis"

  vpc_id    = "vpc-xxxxxxxx"
  subnet_id = "subnet-xxxxxxxx"

  store_credentials_in_ssm = true
  password_rotation_months = 3

  redis = {
    name               = "my-redis-cluster"
    availability_zone  = "ap-guangzhou-3"
    mem_size           = 8
    type_id            = 18   # Redis 7.0 cluster
    shard_num          = 2
    replicas_num       = 1
    replica_zone_names = ["ap-guangzhou-3", "ap-guangzhou-4"]
    ssl_enabled        = true
    password_length    = 32
  }

  backup_strategy = {
    backup_time = "04:00-05:00"
  }

  storage_strategy = {
    storage_days = 30
    remark       = "Daily backup retention"
  }
}
```

> **Notes**:
> - `replica_zone_names` are validated against the zones returned by the `tencentcloud_zones` data source; an invalid name fails the plan with a clear error.
> - When `no_auth = true`, no password is set and SSM secret / rotation are skipped. Provided passwords are not rotated.
