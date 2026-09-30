# terraform-tencentcloud-cdb-mysql-instance
Terraform module which creates a TencentDB for MySQL (CDB) instance on TencentCloud.

This module uses the following resources:

- `tencentcloud_mysql_instance` — create the MySQL instance (with optional random generated root password).
- `tencentcloud_mysql_instance_encryption_operation` — enable data encryption (optional).
- `tencentcloud_mysql_backup_policy` — configure backup & binlog retention (optional).
- `tencentcloud_mysql_database` — create databases (optional).
- `tencentcloud_mysql_account` + `tencentcloud_mysql_privilege` — create accounts and grant privileges (optional).

> If `instance_id` is not provided, a new instance is created and a random 32-character root password is generated automatically. Otherwise the module manages an existing instance.

## Usage

```hcl
module "mysql" {
  source = "terraform-tencentcloud-modules/cdb-mysql-instance/tencentcloud"

  instance_name = "mysql-test"
  mem_size      = 2000          # Memory size in MB
  volume_size   = 50            # Disk size in GB
  engine_version = "8.0"

  charge_type = "POSTPAID"
  vpc_id      = "vpc-xxxxxxxx"
  subnet_id   = "subnet-xxxxxxxx"

  # Optional: create databases, accounts and privileges
  databases = [
    {
      db_name            = "appdb"
      character_set_name = "utf8mb4"
    }
  ]

  mysql_accounts = [
    {
      name   = "appuser"
      host   = "%"
      global = ["SELECT", "INSERT", "UPDATE", "DELETE"]
    }
  ]

  # Optional: backup policy
  create_backup_policy = true
  retention_period     = 7
}
```

## Examples

- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cdb-mysql-instance/tree/master/example)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| tencentcloud | > 1.18.1 |
| random | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `instance_id` | The id of an existing MySQL instance. If null, a new instance is created. | `string` | `null` | no |
| `instance_name` | The name of the MySQL instance (1-100 chars). | `string` | n/a | **yes** |
| `mem_size` | Memory size (in MB). | `number` | n/a | **yes** |
| `volume_size` | Disk size (in GB). | `number` | n/a | **yes** |
| `cpu_cores` | CPU cores. Computed if omitted. | `number` | `null` | no |
| `project_id` | Project ID. | `number` | `0` | no |
| `charge_type` | Pay type: `PREPAID`, `POSTPAID`. | `string` | `POSTPAID` | no |
| `prepaid_period` | Period (months) for PREPAID. One of 1-12, 24, 36. | `number` | `1` | no |
| `auto_renew_flag` | Auto renew flag (0/1), only for PREPAID. | `number` | `0` | no |
| `availability_zone` | Availability zone to use. | `string` | `null` | no |
| `root_password` | Root account password (sensitive). Ignore for read-only/disaster recovery instances. | `string` | `null` | no |
| `slave_deploy_mode` | AZ deploy mode: 0 - Single AZ; 1 - Multiple AZ. | `number` | `0` | no |
| `first_slave_zone` | Zone of the first slave instance. | `string` | `null` | no |
| `second_slave_zone` | Zone of the second slave instance. | `string` | `null` | no |
| `slave_sync_mode` | Data replication mode: 0 - Async; 1 - Semisync; 2 - Strongsync. | `number` | `0` | no |
| `intranet_port` | Intranet access port [1024-65535]. | `number` | `3306` | no |
| `vpc_id` | ID of VPC. | `string` | `null` | no |
| `subnet_id` | Private network ID. Required when `vpc_id` is set. | `string` | `null` | no |
| `security_groups` | Security groups to use. | `list(string)` | `[]` | no |
| `param_template_id` | Parameter template id. | `number` | `null` | no |
| `fast_upgrade` | Fast upgrade on spec change (1 enabled, 0 disabled). | `number` | `null` | no |
| `device_type` | Device type: `UNIVERSAL`, `EXCLUSIVE`, `BASIC_V2`, `CLOUD_NATIVE_CLUSTER`, `CLOUD_NATIVE_CLUSTER_EXCLUSIVE`. | `string` | `null` | no |
| `disk_type` | Disk type (ForceNew): `CLOUD_SSD`, `CLOUD_HSSD`, `CLOUD_PREMIUM`. | `string` | `null` | no |
| `force_delete` | Force delete directly (skip recycle bin). Only for PREPAID. | `bool` | `false` | no |
| `wait_switch` | Switch method to new instance: 0 - immediate, 1 - in time window. | `number` | `0` | no |
| `destroy_protect` | Destroy protection status: `on` / `off`. | `string` | `null` | no |
| `cluster_topology` | Cluster Edition node topology (read_write_node + read_only_nodes). Required for cluster edition. | `list(object)` | `[]` | no |
| `encryption_enabled` | Whether to enable data encryption. | `bool` | `false` | no |
| `encryption_key_id` | Key ID for data encryption. | `string` | `null` | no |
| `encryption_key_region` | Key region for data encryption. | `string` | `null` | no |
| `parameters` | List of parameters (key-value map). | `map(string)` | `null` | no |
| `internet_service` | Enable public network access: 0 - No, 1 - Yes. | `number` | `0` | no |
| `engine_version` | Engine version: 5.5/5.6/5.7/8.0/8.4. | `string` | `5.7` | no |
| `engine_type` | Engine type: `InnoDB` (default) or `RocksDB`. | `string` | `InnoDB` | no |
| `upgrade_subversion` | Kernel subversion upgrade flag (1 upgrade subversion, 0 upgrade engine version). | `number` | `null` | no |
| `max_deay_time` | Latency threshold (1~10). NOTE: provider schema typo (`deay`). | `number` | `null` | no |
| `tags` | Instance tags. | `map(string)` | `{}` | no |
| `create_backup_policy` | Whether to create a MySQL backup policy. | `bool` | `false` | no |
| `backup_model` | Backup method: `physical` (physical backup). | `string` | `physical` | no |
| `backup_time` | Backup time window "HH:mm-HH:mm" (4h interval). | `string` | `02:00-06:00` | no |
| `retention_period` | Backup retention days [7-730]. | `number` | `7` | no |
| `binlog_period` | Binlog retention days [7-1830]. | `number` | `7` | no |
| `enable_binlog_standby` | Log backup standard storage policy: `off` / `on`. | `string` | `off` | no |
| `binlog_standby_days` | Standard starting days for log backup storage (min 30). | `number` | `null` | no |
| `databases` | Databases to create (`db_name`, `character_set_name`). | `list(object)` | `[]` | no |
| `mysql_accounts` | Accounts to create with global/database/table/column privileges. | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `db_instance_id` | The instance id of the MySQL instance. |
| `gtid` | Whether GTID is activated. |
| `internet_host` | Host for public access. |
| `internet_port` | Access port for public access. |
| `intranet_ip` | Instance intranet IP. |
| `locked` | Whether the instance is locked (0 - No, 1 - Yes). |
| `status` | Instance status (0 - Creating, 1 - Running, 4 - Isolating, 5 - Isolated). |
| `task_status` | Kind of operation currently being executed. |
| `root_password` | Root password (sensitive). |
| `backup_policy_id` | The id of the backup policy. |
| `binlog_period` | Retention period for binlog in days. |
| `account_ids` | Map of created account ids. |
| `account_passwords` | Map of account passwords (sensitive). |
| `mysql_privilege_ids` | Map of created privilege resource ids. |

***

## Authors and acknowledgment

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
