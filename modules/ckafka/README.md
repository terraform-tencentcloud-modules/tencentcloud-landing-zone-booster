# terraform-tencentcloud-ckafka

A Terraform module used to create TencentCloud CKafka (Message Queue CKafka) resources, including instance, topic, route (access point), user and ACL.

## Examples
```hcl
module "ckafka" {
  source = "../../tc-modules/modules/ckafka"

  instances = {
    adp = {
      instance_name   = "sme-ckafka-prod"
      zone_id         = 100003
      multi_zone_flag = false
      vpc_id          = "vpc-xxxxxxxx"
      subnet_id       = "subnet-xxxxxxxx"
      charge_type     = "POSTPAID_BY_HOUR"
      specifications_type = "profession"
      instance_type   = 1
      kafka_version   = "2.4.1"
      disk_type       = "CLOUD_SSD"
      disk_size       = 200
      band_width      = 40
      partition       = 400
      msg_retention_time = 10080
      tag_set = {
        Environment = "prod"
        Product     = "boostsme"
      }
      config = {
        auto_create_topic_enable   = true
        default_num_partitions     = 3
        default_replication_factor = 2
      }
    }
  }

  topics = {
    orders = {
      instance_key       = "adp"
      topic_name         = "orders-topic"
      partition_num      = 6
      replica_num        = 2
      enable_white_list  = false
      retention          = 7200000
      clean_up_policy    = "delete"
    }
  }

  routes = {
    vpc_route = {
      instance_key = "adp"
      vip_type     = 3
      vpc_id       = "vpc-xxxxxxxx"
      subnet_id    = "subnet-xxxxxxxx"
      access_type  = 0
    }
  }

  users = {
    app = {
      instance_key = "adp"
      account_name = "app-user"
      password     = "YourStrongPassword123!"
    }
  }

  acls = {
    app_read = {
      instance_key   = "adp"
      resource_type  = "TOPIC"
      resource_name  = "orders-topic"
      operation_type = "READ"
      permission_type = "ALLOW"
      principal      = "app-user"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instances | A map of CKafka instances to create. The key is used as the instance identifier. | `map(object)` | `{}` | no |
| topics | A map of CKafka topics to create. Each topic references an instance via `instance_key`. | `map(object)` | `{}` | no |
| routes | A map of CKafka VPC routes (access points) to create. Each route references an instance via `instance_key`. | `map(object)` | `{}` | no |
| users | A map of CKafka users (accounts) to create. Each user references an instance via `instance_key`. | `map(object)` | `{}` | no |
| acls | A map of CKafka ACL rules to create. Each ACL references an instance via `instance_key`. | `map(object)` | `{}` | no |

### `instances` object
| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| instance_name | Instance name. | `string` | - |
| zone_id | Available zone id (Int). | `number` | - |
| multi_zone_flag | Whether the instance is multi zones. If `true`, `zone_ids` must be set. | `bool` | `false` |
| zone_ids | List of available zone id (Int). Must be set together with `multi_zone_flag`. | `set(number)` | `null` |
| vpc_id | Vpc id, basic network if not set. | `string` | `null` |
| subnet_id | Subnet id, basic network if not set. | `string` | `null` |
| charge_type | Charge type of instance. `PREPAID` / `POSTPAID_BY_HOUR`. | `string` | `PREPAID` |
| period | Prepaid purchase time in months. | `number` | `null` |
| instance_type | Description of instance type. `profession`:1; `standard`:1-9. | `number` | `null` |
| specifications_type | Specifications type. `standard` / `profession` / `premium`. | `string` | `profession` |
| upgrade_strategy | POSTPAID_BY_HOUR scale-down mode. 1: stable; 2: high-speed. | `number` | `1` |
| kafka_version | Kafka version. `0.10.2` / `1.1.1` / `2.4.1`. | `string` | `null` |
| disk_type | Disk type for profession. `CLOUD_SSD` / `CLOUD_BASIC`. | `string` | `null` |
| disk_size | Disk size (GB). | `number` | `null` |
| band_width | Instance bandwidth in MBps. | `number` | `null` |
| partition | Partition size. | `number` | `null` |
| msg_retention_time | Max retention time in minutes (default 10080 = 7 days). | `number` | `null` |
| renew_flag | Prepaid auto-renewal mark. 0 default, 1 auto, 2 no auto. | `number` | `null` |
| public_network | Bandwidth of the public network. | `number` | `null` |
| max_message_byte | Instance level single message size (1024 - 12582912 bytes). | `number` | `null` |
| elastic_bandwidth_switch | Elastic bandwidth switch. 0 off, 1 on. | `number` | `null` |
| custom_ssl_cert_id | Custom certificate id (profession only). | `string` | `null` |
| delete_protection_enable | Instance delete protection. 1 enable, 0 disable. | `number` | `null` |
| tag_set | Tag set of instance. | `map(string)` | `null` |
| config | Instance configuration object (`auto_create_topic_enable`, `default_num_partitions`, `default_replication_factor`). | `object` | `null` |
| dynamic_retention_config | Dynamic retention policy object (`enable`, `disk_quota_percentage`, `step_forward_percentage`, `bottom_retention`). | `object` | `null` |

### `topics` object
| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| instance_key | Key of the instance in `instances`. | `string` | - |
| topic_name | Name of the CKafka topic. | `string` | - |
| partition_num | The number of partition. | `number` | - |
| replica_num | The number of replica. Max 3. | `number` | - |
| enable_white_list | Whether to open the ip whitelist. | `bool` | `false` |
| ip_white_list | Ip whitelist. | `list(string)` | `null` |
| note | The subject note. | `string` | `null` |
| retention | Message retention time in ms. Range [60000, 7776000000]. | `number` | `60000` |
| sync_replica_min_num | Min number of sync replicas. | `number` | `1` |
| clean_up_policy | Clear log policy. `delete` / `compact` / `compact,delete`. | `string` | `delete` |
| unclean_leader_election_enable | Allow unsynchronized replicas as leader. | `bool` | `false` |
| segment | Segment rolling time in ms (min 3600000). | `number` | `null` |

### `routes` object
| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| instance_key | Key of the instance in `instances`. | `string` | - |
| vip_type | Routing network type. 3: vpc; 4: standard support; 7: profession support. | `number` | - |
| vpc_id | Vpc id. | `string` | `null` |
| subnet_id | Subnet id. | `string` | `null` |
| access_type | Access type. 0: PLAINTEXT; 1: SASL_PLAINTEXT; 2: SSL; 3: SASL_SSL. | `number` | `null` |
| auth_flag | Auth flag. | `number` | `null` |
| caller_appid | Caller appid. | `number` | `null` |
| public_network | Public network. | `number` | `null` |
| ip | Ip. | `string` | `null` |

### `users` object
| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| instance_key | Key of the instance in `instances`. | `string` | - |
| account_name | Account name used to access the instance. | `string` | - |
| password | Password of the account (sensitive). | `string` | - |

### `acls` object
| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| instance_key | Key of the instance in `instances`. | `string` | - |
| resource_type | ACL resource type. `TOPIC` by default. | `string` | `TOPIC` |
| resource_name | ACL resource name (topic/group name). | `string` | - |
| operation_type | ACL operation mode. `READ`/`WRITE`/`ALL`/... | `string` | - |
| permission_type | ACL permission type. `ALLOW` by default. | `string` | `ALLOW` |
| host | Host, default `*`. | `string` | `*` |
| principal | User list, default `*`. | `string` | `*` |

## Outputs

| Name | Description |
|------|-------------|
| instance_ids | The map of CKafka instance IDs keyed by the instance identifier. |
| instance_vips | The map of CKafka instance VIPs keyed by the instance identifier. |
| instance_vports | The map of CKafka instance vports keyed by the instance identifier. |
| topic_ids | The map of CKafka topic IDs keyed by the topic identifier. |
| route_ids | The map of CKafka route IDs keyed by the route identifier. |
| user_ids | The map of CKafka user IDs keyed by the user identifier. |
| acl_ids | The map of CKafka ACL IDs keyed by the ACL identifier. |

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
