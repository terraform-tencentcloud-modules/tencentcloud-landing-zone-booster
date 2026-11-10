# TencentCloud CVM Instance Module for Terraform

## terraform-tencentcloud-cvm-instance

A terraform module that creates a TencentCloud CVM (Cloud Virtual Machine) instance (`tencentcloud_instance`). It can optionally:

- Attach newly created CBS cloud disks (`tencentcloud_cbs_storage` + attachment) and/or existing CBS disks by ID.
- Attach existing ENIs (`tencentcloud_eni_attachment`).
- Create a placement group (`tencentcloud_placement_group`) when `placement_group_name` is provided, or join an existing one via `placement_group_id`.
- Auto-resolve the instance type from `cpu_core_count`/`memory_size` and the image ID from `image_os_name` when not explicitly set, and generate a random login password when neither `key_ids` nor `password` is supplied.

## Usage

```hcl
module "cvm_instance" {
  source = "terraform-tencentcloud-modules/cvm-instance/tencentcloud"

  # basic
  instance_name     = "my-cvm"
  availability_zone = "ap-guangzhou-3"
  instance_type     = "S5.MEDIUM4"        # optional: auto-resolved from cpu/memory if omitted
  image_id          = "img-xxxxxxxx"      # optional: auto-resolved from image_os_name if omitted

  # network
  vpc_id    = "vpc-xxxxxxxx"
  subnet_id = "subnet-xxxxxxxx"

  # login
  password = "MyP@ssw0rd123"              # optional: a random password is generated if both key_ids and password are empty

  # system disk
  system_disk_type = "CLOUD_PREMIUM"
  system_disk_size = 50

  # data disks (newly created CBS)
  data_disks = [
    {
      data_disk_type = "CLOUD_SSD"
      data_disk_size = 100
    }
  ]

  # attach existing CBS / ENI (optional)
  cbs_block_device_ids = []
  eni_ids              = []

  tags = {
    created_by = "terraform"
  }
}
```

## Inputs

### Data source (instance type / image)

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| exclude_sold_out | Indicate to filter instance types that is sold out or not. | bool | false | no |
| cpu_core_count | The number of CPU cores of the instance. Used to resolve `instance_type` when not set. | number | 2 | no |
| memory_size | Instance memory capacity, unit in GB. Used to resolve `instance_type` when not set. | number | 2 | no |
| image_os_name | A string to apply with fuzzy match to the os_name attribute on the image list returned by TencentCloud. | string | null | no |

### Basic instance config

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project_id | Project id. | number | 0 | no |
| instance_name | The name of instance to create. | string | null | no |
| availability_zone | The available zone for the instance. | string | null | no |
| instance_type | Instance type of instance. Auto-resolved from `cpu_core_count`/`memory_size` when null. | string | null | no |
| image_id | The image to use for the instance. Changing image_id will cause the instance reset. | string | null | no |
| host_name | The hostname of the instance. Changing the `hostname` will cause the instance system to restart. | string | null | no |

### Storage

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| system_disk_id | System disk snapshot ID used to initialize the system disk. Not supported when type is LOCAL_BASIC/LOCAL_SSD. | string | null | no |
| system_disk_name | Name of the system disk. | string | null | no |
| system_disk_type | System disk type. Valid values: LOCAL_BASIC, LOCAL_SSD, CLOUD_BASIC, CLOUD_SSD, CLOUD_PREMIUM, CLOUD_BSSD, CLOUD_HSSD, CLOUD_TSSD. | string | "CLOUD_PREMIUM" | no |
| system_disk_size | Size of the system disk, unit is GB. | number | 50 | no |
| system_disk_resize_online | Resize online. | bool | null | no |
| data_disks | Settings for data disks (list of objects: data_disk_type, data_disk_size, data_disk_name, data_disk_snapshot_id, data_disk_id, delete_with_instance, delete_with_instance_prepaid, kms_key_id, encrypt, throughput_performance). | list(object) | [] | no |

### VPC & network

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc_id | The ID of a VPC network. If not set, the default VPC will be used. | string | null | no |
| subnet_id | The ID of a VPC subnet. If not set, the default subnet will be used. | string | null | no |
| private_ip | Private IP address to associate with the instance in a VPC. Must be within the subnet specified by subnet_id. | string | null | no |
| security_group_ids | A list of orderly security group IDs to associate with. | list(string) | null | no |
| allocate_public_ip | Associate a public IP address with an instance in a VPC or Classic. | bool | false | no |
| internet_charge_type | Internet charge type of the instance. Valid values: BANDWIDTH_PREPAID, TRAFFIC_POSTPAID_BY_HOUR, BANDWIDTH_POSTPAID_BY_HOUR, BANDWIDTH_PACKAGE. | string | null | no |
| bandwidth_package_id | Bandwidth package id. | string | null | no |
| internet_max_bandwidth_out | Maximum outgoing bandwidth to the public network, in Mbps. | number | 10 | no |
| ipv4_address_type | IPv4 AddressType. Default: WanIP. Valid values: WanIP, HighQualityEIP, AntiDDoSEIP. | string | null | no |
| ipv6_address_type | IPv6 AddressType. Default: WanIP. Valid values: EIPv6, HighQualityEIPv6. | string | null | no |
| ipv6_address_count | Specify the number of randomly generated IPv6 addresses for the ENI. | number | null | no |
| anti_ddos_package_id | Anti-DDoS service package ID. Required when requesting an AntiDDoS IP. | string | null | no |

### Enhanced services

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable_security_service | Enable enhanced security service (security agent). Default is enabled. | bool | true | no |
| enable_monitor_service | Enable enhanced monitor service (monitor agent). Default is enabled. | bool | true | no |
| enable_automation_service | Enable enhanced automation service. Default is enabled. | bool | true | no |

### Login, role & HPC

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| key_ids | The key pair IDs to use for the instance, e.g. `skey-16jig7tx`. | list(string) | null | no |
| password | Login password of the instance (sensitive). A random password is generated when both key_ids and password are empty. | string | null | no |
| keep_image_login | Whether to keep image login. Default is false. | bool | null | no |
| user_data | Base64-encoded binary user data. Use instead of user_data_raw for non-UTF-8 content. | string | null | no |
| user_data_raw | The user data to provide when launching the instance. | string | null | no |
| user_data_replace_on_change | Whether to replace user data on change. Default is false. | bool | false | no |
| cam_role_name | CAM role name authorized to access. | string | null | no |
| hpc_cluster_id | High-performance computing cluster ID. Required only for HPC instances. | string | null | no |

### Payment config

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| instance_charge_type | The charge type of instance. Valid values: PREPAID, POSTPAID_BY_HOUR, SPOTPAID, CDHPAID, CDCPAID, UNDERWRITE. | string | "POSTPAID_BY_HOUR" | no |
| instance_charge_type_prepaid_period | The tenancy (month) of the prepaid instance. Only works when PREPAID. Valid values: 1-12, 24, 36, 48, 60. | string | "1" | no |
| instance_charge_type_prepaid_renew_flag | Auto renewal flag for prepaid instances. Valid values: NOTIFY_AND_AUTO_RENEW, NOTIFY_AND_MANUAL_RENEW, DISABLE_NOTIFY_AND_MANUAL_RENEW. | string | "NOTIFY_AND_MANUAL_RENEW" | no |
| spot_instance_type | Type of spot instance, only `ONE-TIME` supported. Only works when SPOTPAID. | string | null | no |
| spot_max_price | Max price of a spot instance, decimal string e.g. "0.50". Only works when SPOTPAID. | string | null | no |
| cdh_instance_type | Type of instance created on CDH, format CDH_XCXG. Only works when CDHPAID. | string | null | no |
| cdh_host_id | Id of CDH instance. Only works when CDHPAID. | string | null | no |

### Disaster recovery, stop & delete

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| disaster_recover_group_ids | Disaster recover group IDs. | list | null | no |
| stop_type | Instance shutdown mode. Valid values: SOFT_FIRST, HARD, SOFT. | string | "SOFT" | no |
| stopped_mode | Billing method after shutdown for pay-as-you-go instances. Valid values: KEEP_CHARGING, STOP_CHARGING. | string | "KEEP_CHARGING" | no |
| force_delete | Force delete the instance (skip recycle bin). Only works for PREPAID. | bool | false | no |
| disable_api_termination | Whether termination protection is enabled. | bool | false | no |

### Placement group

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| placement_group_id | The Placement Group Id to start the instance in. | string | null | no |
| placement_group_name | The Placement group name to create and start the instance in. Ignored if placement_group_id is passed. | string | null | no |
| placement_group_type | Type of the placement group. Valid values: HOST, SW, RACK. | string | null | no |
| force_replace_placement_group_id | Whether to force the instance host to be replaced. Only useful when changing placement_group_id. | bool | false | no |

### CBS & ENI attachments

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cbs_block_devices | Additional CBS block devices to create and attach (list of objects, see `tencentcloud_cbs_storage`). | list(object) | [] | no |
| cbs_block_device_ids | Attach existing CBS block devices to the instance by id. | list(string) | [] | no |
| cbs_tags | Additional tags to assign to the created CBS resources. | map(string) | {} | no |
| eni_ids | A list of ENI IDs to bind with the instance. | list(string) | [] | no |

### Tags

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| tags | A mapping of tags to assign to the resource. | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | The id of the instance. |
| instance_uuid | The uuid of the instance. |
| instance_status | The state of the instance. |
| public_ip | The public ip of the instance. |
| private_ip | The private ip of the instance. |
| placement_group_id | The Placement Group Id to start the instance in. |
| password | The password of the instance (sensitive). |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cvm-instance)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
