# CDB MySQL Readonly Terraform Module

This module provisions one or more **Tencent Cloud MySQL Readonly (RO) instances** (`tencentcloud_mysql_readonly_instance`) under a single RO group.

Key behaviors:

- If no `ro_group_id` is provided in `ro_basic`, the **first** instance (by sorted key) creates a new RO group, and all remaining instances join that group automatically.
- If `ro_group_id` is provided, **all** instances join the specified existing RO group, and only the remaining instances are created (the "first instance" resource is not created since `first_key` is `null`).
- Instance keys are sorted to ensure consistent creation ordering across applies.

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
| `tencentcloud_mysql_readonly_instance.ro_first` | resource (count = 1, created only when a new RO group must be created) |
| `tencentcloud_mysql_readonly_instance.ro_remaining` | resource (for_each, joins existing RO group) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ro_basic"></a> [ro\_basic](#input\_ro\_basic) | `object` | no | `null` | MySQL readonly basic configuration shared by all instances (master, network, RO group, etc.). |
| <a name="input_ro_instances"></a> [ro\_instances](#input\_ro\_instances) | `map(object)` | no | `{}` | MySQL readonly instances configuration, keyed by instance identifier. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags applied to all readonly instances. |

### `ro_basic` object

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `master_instance_id` | `string` | yes | Master instance ID. |
| `master_region` | `string` | no | Master instance region (required for cross-region readonly). |
| `ro_group_id` | `string` | no | RO group ID. If set, all instances join this group; if empty, the first instance creates a new group. |
| `zone` | `string` | no | Availability zone. |
| `vpc_id` | `string` | no | VPC ID. |
| `subnet_id` | `string` | no | Subnet ID. |
| `security_groups` | `list(string)` | no | Security group IDs (default `[]`). |
| `intranet_port` | `number` | no | Intranet port. |

### `ro_instances` map element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `instance_name` | `string` | yes | – | Instance name. |
| `slave_deploy_mode` | `number` | no | `0` | Deploy mode: `0` (single-zone), `1` (multi-zone). |
| `cpu` | `number` | yes | – | CPU cores. |
| `mem_size` | `number` | yes | – | Memory size in MB. |
| `volume_size` | `number` | yes | – | Storage size in GB. |
| `device_type` | `string` | no | `"UNIVERSAL"` | Device type. |
| `charge_type` | `string` | no | `"POSTPAID"` | Charge type: `PREPAID` or `POSTPAID`. |
| `prepaid_period` | `number` | no | `1` | Prepaid period in months. |
| `auto_renew_flag` | `number` | no | `0` | Auto-renew flag: `0` (off), `1` (on). |
| `force_delete` | `bool` | no | `false` | Force delete instance. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ro_group_id"></a> [ro\_group\_id](#output\_ro\_group\_id) | The RO group ID (shared by all readonly instances). `null` when no instance is created. |
| <a name="output_ro_instance_ids"></a> [ro\_instance\_ids](#output\_ro\_instance\_ids) | Map of instance identifier to readonly instance ID. |
| <a name="output_ro_intranet_ips"></a> [ro\_intranet\_ips](#output\_ro\_intranet\_ips) | Map of instance identifier to readonly instance intranet IP. |
| <a name="output_ro_intranet_ports"></a> [ro\_intranet\_ports](#output\_ro\_intranet\_ports) | Map of instance identifier to readonly instance intranet port. |
| <a name="output_ro_status"></a> [ro\_status](#output\_ro\_status) | Map of instance identifier to readonly instance status. |

## Usage

### Create a new RO group with multiple instances

```hcl
module "mysql_ro" {
  source = "./modules/cdb-mysql-readonly"

  tags = {
    env = "prod"
  }

  ro_basic = {
    master_instance_id = "cdb-xxxxxxxx"
    master_region      = "ap-guangzhou"
    zone               = "ap-guangzhou-3"
    vpc_id             = "vpc-xxxxxxxx"
    subnet_id          = "subnet-xxxxxxxx"
    security_groups    = ["sg-xxxxxxxx"]
    intranet_port      = 3306
    # ro_group_id is empty → first instance creates a new RO group
  }

  ro_instances = {
    ro-a = {
      instance_name     = "mysql-ro-a"
      cpu               = 2
      mem_size          = 4000
      volume_size       = 200
      slave_deploy_mode = 0
      device_type       = "UNIVERSAL"
      charge_type       = "POSTPAID"
    }
    ro-b = {
      instance_name     = "mysql-ro-b"
      cpu               = 4
      mem_size          = 8000
      volume_size       = 500
      slave_deploy_mode = 1
      charge_type       = "PREPAID"
      prepaid_period    = 12
      auto_renew_flag   = 1
      force_delete      = false
    }
  }
}
```

### Join an existing RO group

```hcl
module "mysql_ro" {
  source = "./modules/cdb-mysql-readonly"

  ro_basic = {
    master_instance_id = "cdb-xxxxxxxx"
    ro_group_id        = "sqls-xxxxxxxx"  # all instances join this existing group
    zone               = "ap-guangzhou-3"
    vpc_id             = "vpc-xxxxxxxx"
    subnet_id          = "subnet-xxxxxxxx"
  }

  ro_instances = {
    ro-c = {
      instance_name = "mysql-ro-c"
      cpu           = 2
      mem_size      = 4000
      volume_size   = 200
    }
  }
}
```
