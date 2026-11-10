# CDB PostgreSQL Readonly Terraform Module

This module provisions one **PostgreSQL Readonly (RO) group** (`tencentcloud_postgresql_readonly_group`) and one or more **PostgreSQL Readonly instances** (`tencentcloud_postgresql_readonly_instance`) attached to that group.

Key behaviors:

- A single RO group is always created first, then all instances in `ro_instances` are attached to it via `read_only_group_id`.
- Each instance is keyed by an identifier in the `ro_instances` map, allowing multiple instances of different specs to be created under the same group.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | >= 1.60.18 |

## Providers

| Provider | Source |
|----------|--------|
| tencentcloud | tencentcloudstack/tencentcloud |

## Resources

| Name | Type |
|------|------|
| `tencentcloud_postgresql_readonly_group.ro_group` | resource |
| `tencentcloud_postgresql_readonly_instance.ro` | resource (for_each over `ro_instances`) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ro_group"></a> [ro\_group](#input\_ro\_group) | `object` | no | `null` | PostgreSQL readonly group configuration. |
| <a name="input_ro_instances"></a> [ro\_instances](#input\_ro\_instances) | `map(object)` | no | `{}` | PostgreSQL readonly instances configuration, keyed by instance identifier. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags applied to all readonly instances. |

### `ro_group` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Readonly group name. |
| `master_db_instance_id` | `string` | yes | – | Master instance ID. |
| `project_id` | `number` | no | `0` | Project ID. |
| `vpc_id` | `string` | yes | – | VPC ID. |
| `subnet_id` | `string` | yes | – | Subnet ID. |
| `security_groups_ids` | `list(string)` | no | `[]` | Security group IDs. |
| `replay_lag_eliminate` | `number` | no | `0` | Enable lag-based elimination. `0`: no, `1`: yes. |
| `replay_latency_eliminate` | `number` | no | `0` | Enable latency-based elimination. `0`: no, `1`: yes. |
| `max_replay_lag` | `number` | no | `0` | Lag threshold in milliseconds. |
| `max_replay_latency` | `number` | no | `0` | Latency threshold in MB. |
| `min_delay_eliminate_reserve` | `number` | no | `1` | Minimum reserved readonly instances. |

### `ro_instances` map element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Instance name. |
| `zone` | `string` | yes | – | Availability zone. |
| `db_version` | `string` | yes | – | PostgreSQL version, must match master. |
| `charge_type` | `string` | no | `"POSTPAID_BY_HOUR"` | Billing mode: `PREPAID` or `POSTPAID_BY_HOUR`. |
| `memory` | `number` | yes | – | Memory size in GB. |
| `cpu` | `number` | yes | – | CPU cores. |
| `storage` | `number` | yes | – | Storage capacity in GB. |
| `need_support_ipv6` | `number` | no | `0` | IPv6 support. `0`: no, `1`: yes. |
| `auto_renew_flag` | `number` | no | – | Auto-renew flag for PREPAID. `0`: off, `1`: on. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ro_group_id"></a> [ro\_group\_id](#output\_ro\_group\_id) | The ID of the PostgreSQL readonly group. |
| <a name="output_ro_group_net_info_list"></a> [ro\_group\_net\_info\_list](#output\_ro\_group\_net\_info\_list) | The network info list of the PostgreSQL readonly group. |
| <a name="output_ro_instance_ids"></a> [ro\_instance\_ids](#output\_ro\_instance\_ids) | Map of instance identifier to PostgreSQL readonly instance ID. |
| <a name="output_ro_private_access_ips"></a> [ro\_private\_access\_ips](#output\_ro\_private\_access\_ips) | Map of instance identifier to readonly instance private access IP. |
| <a name="output_ro_private_access_ports"></a> [ro\_private\_access\_ports](#output\_ro\_private\_access\_ports) | Map of instance identifier to readonly instance private access port. |

## Usage

```hcl
module "pg_ro" {
  source = "./modules/cdb-postgres-readonly"

  tags = {
    env = "prod"
  }

  ro_group = {
    name                        = "pg-ro-group"
    master_db_instance_id       = "postgres-xxxxxxxx"
    project_id                  = 0
    vpc_id                      = "vpc-xxxxxxxx"
    subnet_id                   = "subnet-xxxxxxxx"
    security_groups_ids         = ["sg-xxxxxxxx"]
    replay_lag_eliminate        = 1
    replay_latency_eliminate    = 1
    max_replay_lag              = 100
    max_replay_latency          = 200
    min_delay_eliminate_reserve = 1
  }

  ro_instances = {
    ro-a = {
      name          = "pg-ro-a"
      zone          = "ap-guangzhou-3"
      db_version    = "13.0"
      charge_type   = "POSTPAID_BY_HOUR"
      memory        = 4
      cpu           = 2
      storage       = 200
      need_support_ipv6 = 0
      auto_renew_flag   = 0
    }
    ro-b = {
      name          = "pg-ro-b"
      zone          = "ap-guangzhou-4"
      db_version    = "13.0"
      charge_type   = "PREPAID"
      memory        = 8
      cpu           = 4
      storage       = 500
      auto_renew_flag = 1
    }
  }
}
```
