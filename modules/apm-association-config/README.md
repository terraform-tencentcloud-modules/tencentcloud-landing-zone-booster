# TencentCloud Bastion Module for Terraform

## terraform-tencentcloud-bastion

Terraform module to define a generic Bastion host with parameterized user_data.

The following modules are included.

* [security-group](https://registry.terraform.io/modules/terraform-tencentcloud-modules/security-group/tencentcloud/latest)
* [cvm](https://registry.terraform.io/modules/terraform-tencentcloud-modules/cvm/tencentcloud/latest)

The following resources are included.

* [tencentcloud_eip](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/eip)
* [tencentcloud_eip_association](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/eip_association)
* [tencentcloud_dnspod_domain_instance](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/dnspod_domain_instance)
* [tencentcloud_dnspod_record](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/dnspod_record)
* [tencentcloud_private_dns_zone](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/private_dns_zone)
* [tencentcloud_private_dns_record](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/private_dns_record)


These features of Bastion host configurations are supported:
- Create a CVM instance and associate it with an elastic eip
- Configure security group rules for the cvm instance, including ingress and egress rules
- Set the ssh key to log in to the cvm instance
- Configure the private domain dns to resolve the cvm host
- Configure the public domain dns to resolve the cvm host
- Set the custom user_data to create the cvm instance
- Define the cam role of the CVM instance
- Mount the cbs cloud disk for the cvm instance



## Examples:

- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-bastion/tree/main/examples/complete
) - A complete example of Bastion features
- [No-Eip](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-bastion/tree/main/examples/no-eip) 
- A  example of define a generic Bastion host without eip
- [Public-DNS](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-bastion/tree/main/examples/public-dns) 
- A  example of define a generic Bastion host and resolve hosts using the public dns domain name


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.18.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.18.1 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| image_name_regex | A regex string to apply to the image list returned by TencentCloud, conflict with 'os_name'. | string | null | no
| os_name | A string to apply with fuzzy match to the os_name attribute on the image list returned by TencentCloud, conflict with 'image_name_regex'. | string | null | no
| image_id | The image to use for the instance. Changing image_id will cause the instance reset. | string | null | no
| image_type | A list of the image type to be queried. Valid values: 'PUBLIC_IMAGE', 'PRIVATE_IMAGE', 'SHARED_IMAGE', 'MARKET_IMAGE'. | list(string) | [] | no
| create_security_group | Whether to create default Security Group for bastion host. | bool | default | true
| security_group_description | The Security Group description. | string | "Bastion host security group" | no
| security_group_name | The Security Group name. | string | "" | no
| ingress_with_cidr_blocks | List of ingress rules to create where `cidr_block` is used.The values of map is fully complated with `security_group_rule` resource. | list(map(string)) | [] | no
| egress_with_cidr_blocks | List of egress rules to create where `cidr_block` is used.The values of map is fully complated with `security_group_rule` resource. | list(map(string)) | [] | no
| create_instance | Whether to create cvm instance.. | bool | true | no
| instance_name | The name of instance to create. | string | null | no
| availability_zone |The available zone for the instance.| string | null | no
| instance_type | Instance type of instance. | string | null | no
| system_disk_type |System disk type. For more information on limits of system disk types, see Storage Overview. Valid values: LOCAL_BASIC: local disk, LOCAL_SSD: local SSD disk, CLOUD_SSD: SSD, CLOUD_PREMIUM: Premium Cloud . | string | "CLOUD_PREMIUM" | no
| system_disk_size |Size of the system disk. unit is GB, Default is 50GB. If modified, the instance may force stop.| number | 50 | no
| allocate_public_ip |Associate a public IP address with an instance in a VPC or Classic. Boolean value, Default is false. | bool | false | no
| internet_max_bandwidth_out | Maximum outgoing bandwidth to the public network, measured in Mbps (Mega bits per second). This value does not need to be set when allocate_public_ip is false.| number | 10 | no
| vpc_id |The ID of a VPC network. If you want to create instances in a VPC network, this parameter must be set or the default vpc will be used.| string | null | no
| subnet_id | The ID of a VPC subnet. If you want to create instances in a VPC network, this parameter must be set or the default subnet will be used. | string |null | no
| key_ids | Key ids of the Key Pair to use for the instance; which can be managed using the `tencentcloud_key_pair` resource. | list(string) | [] | no
| password | Login password of the instance. For Linux instances, the password must include 8-30 characters, and contain at least two of the following character sets: [a-z], [A-Z], [0-9] and [()`~!@#$%^&*-+= | string | null | no
| security_group_ids | A list of orderly security group IDs to associate with. | list(string)| [] | no
| cbs_block_devices | Additional CBS block devices to attach to the instance. see resource tencentcloud_cbs_storage. | list(map(string))| [] | no
| cbs_block_device_ids | Attach exist CBS block devices to the instance by id.  see resource tencentcloud_cbs_storage. | list(string)| [] | no
| tags | A mapping of tags to assign to the resource. | map(string)| {} | no
| monitoring | If true, the launched CVM instance will have detailed monitoring enabled. | bool| true | no
| user_data_raw | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead. | string| null | no
| user_data_base64 | Can be used instead of user_data_raw to pass base64-encoded binary data directly. Use this instead of user_data_raw whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption. |string| null | no
| cam_role_name | CAM role name authorized to access. | string| null | no
| disable_api_termination | Whether the termination protection is enabled. Default is false. If set true, which means that this instance can not be deleted by an API action. | bool| false | no
| host_name | The Bastion hostname, which can be used as a domain name to access the Bastion host | string| "" | no
| dns_type | The value can be public or private. If the value is public, the dns can be resolved on the public network. Otherwise, the DNS can be resolved only on the private network. | string | private | no
| create_eip | Whether to create eip for bastion host. | bool | true | no
| eip_name | The Name of the eip . | string| "" | no
| region | The region of instance. | string| "ap-guangzhou" | no


## Outputs

| Name | Description |
|------|-------------|
| instance_id | Instance ID |
| security_group_ids | IDs on the  Security Groups associated with the instance.|
| role | Name of CAM Role associated with the instance |
| public_ip | Public IP of the instance (or EIP) |
| hostname | DNS hostname |
| security_group_id | Bastion host Security Group ID |
| security_group_name | Bastion host Security Group name |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
