# TencentCloud VPC Module for Terraform

## terraform-tencentcloud-vpc

A terraform module used to create TencentCloud VPC, subnet and route entry.

The following resources are included.

* [VPC](https://www.terraform.io/docs/providers/tencentcloud/r/vpc.html)
* [VPC Subnet](https://www.terraform.io/docs/providers/tencentcloud/r/subnet.html)
* [VPC Route Entry](https://www.terraform.io/docs/providers/tencentcloud/r/route_table_entry.html)

## Usage

```hcl
module "vpc" {
  source  = "terraform-tencentcloud-modules/vpc/tencentcloud"
  version = "1.0.3"

  vpc_name = "simple-vpc"
  vpc_cidr = "10.0.0.0/16"

  subnet_name  = "simple-vpc"
  subnet_cidrs = ["10.0.0.0/24"]

  destination_cidrs = ["1.0.1.0/24"]
  next_type         = ["EIP"]
  next_hub          = ["0"]

  tags = {
    module = "vpc"
  }

  vpc_tags = {
    test = "vpc"
  }

  subnet_tags = {
    test = "subnet"
  }
}
```

## Conditional Creation

This module can create VPC and VPC Subnet.
It is possible to use existing VPC when specify `vpc_id` parameter.

## Inputs

| Name                          | Description                                                                                                                                                    |     Type     |    Default    | Required |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------:|:-------------:|:--------:|
| tags                          | A map of tags to add to all resources.                                                                                                                         | map(string)  |      {}       |    no    |
| cpu_core_count                | CPU core count used to query supported available zones.                                                                                                        |    number    |       1       |    no    |
| memory_size                   | Memory size used to query supported available zones.                                                                                                           |    number    |       2       |    no    |
| gpu_core_count                | GPU core count used to query supported available zones.                                                                                                        |    number    |       0       |    no    |
| create_vpc                    | -                                                                                                                                                              |     bool     |     true      |    no    |
| vpc_id                        | The vpc id used to launch resources.                                                                                                                           |    string    |      ""       |    no    |
| vpc_name                      | The vpc name used to launch a new vpc when 'vpc_id' is not specified.                                                                                          |    string    |    my-vpc     |    no    |
| vpc_cidr                      | The cidr block used to launch a new vpc when 'vpc_id' is not specified.                                                                                        |    string    | 172.16.0.0/16 |    no    |
| vpc_is_multicast              | Specify the vpc is multicast when 'vpc_id' is not specified.                                                                                                   |     bool     |     true      |    no    |
| vpc_dns_servers               | Specify the vpc dns servers when 'vpc_id' is not specified.                                                                                                    | list(string) |      []       |    no    |
| vpc_tags                      | Additional tags for the vpc.                                                                                                                                   | map(string)  |      {}       |    no    |
| subnet_name                   | Specify the subnet name when 'vpc_id' is not specified.                                                                                                        |    string    |    subnet     |    no    |
| subnet_cidrs                  | Specify the subnet cidr blocks when 'vpc_id' is not specified.                                                                                                 | list(string) |      []       |    no    |
| subnet_is_multicast           | Specify the subnet is multicast when 'vpc_id' is not specified.                                                                                                |     bool     |     true      |    no    |
| subnet_tags                   | Additional tags for the subnet.                                                                                                                                | map(string)  |      {}       |    no    |
| availability_zones            | List of available zones to launch resources.                                                                                                                   | list(string) |      []       |    no    |
| create_route_table            | -                                                                                                                                                              |     bool     |     true      |    no    |
| route_table_id                | The route table id of router table in the specified vpc.                                                                                                       |    string    |      ""       |    no    |
| destination_cidrs             | List of destination CIDR blocks of router table in the specified VPC.                                                                                          | list(string) |      []       |    no    |
| next_type                     | List of next hop types of router table in the specified vpc.                                                                                                   | list(string) |      []       |    no    |
| next_hub                      | List of next hop gateway id of router table in the specified vpc.                                                                                              | list(string) |      []       |    no    |
| route_table_tags              | Additional tags for the route table.                                                                                                                           | map(string)  |      {}       |    no    |
| enable_vpn_gateway            | Create a new VPN Gateway resource and attach it to the VPC                                                                                                     |     bool     |     false     |    no    |
| vpn_gateway_bandwidth         | bandwidth of VPN Gateway                                                                                                                                       |    number    |       5       |    no    |
| vpn_gateway_max_connection    | Maximum number of connected clients allowed for the SSL VPN gateway. Valid values: [5, 10, 20, 50, 100]. This parameter is only required for SSL VPN gateways. |    number    |       5       |    no    |
| vpn_gateway_type              | Type of VPN gateway. Valid value: IPSEC, SSL and CCN.                                                                                                          |    string    |     IPSEC     |    no    |
| vpn_gateway_availability_zone | The Availability Zone for the VPN Gateway                                                                                                                      |    string    |      ""       |    no    |
| vpn_gateway_tags              | Additional tags for the VPN gateway                                                                                                                            | map(string)  |      {}       |    no    |
| manage_network_acl            | Should be true to adopt and manage Network ACL for subnets                                                                                                     |     bool     |     false     |    no    |
| network_acl_name              | Name to be used on Network ACL                                                                                                                                 |    string    |     null      |    no    |
| network_acl_tags              | Additional tags for the Network ACL                                                                                                                            | map(string)  |      {}       |    no    |
| network_acl_ingress           | List of strings of ingress rules to set on the Network ACL, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`                                                                     | list(string) |     null      |    no    |
| network_acl_egress            | List of strings of egress rules to set on the Network ACL, eg: `ACCEPT#0.0.0.0/0#ALL#ALL`                                                                      | list(string) |     null      |    no    |
| enable_nat_gateway            | Should be true if you want to provision NAT Gateways for vpc.                                                                                                  |     bool     |     false     |    no    |
| nat_gateway_bandwidth         | bandwidth of NAT Gateway                                                                                                                                       |    number    |      100      |    no    |
| nat_gateway_concurrent        | concurrency of NAT Gateway                                                                                                                                     |    number    |    1000000    |    no    |
| nat_gateway_tags              | Additional tags for the NAT gateway                                                                                                                            | map(string)  |      {}       |    no    |
| nat_public_ips                | List of EIPs to be used for `nat_gateway`, will create an new EIP if not set.                                                                                  | list(string) |      []       |    no    |

## Outputs

| Name                          | Description                              |
|-------------------------------|------------------------------------------|
| vpc_id                        | The id of vpc.                           |
| subnet_id                     | The ids of subnet.                       |
| route_table_id                | The id of route table.                   |
| route_entry_id                | The ids of route table entry.            |
| availability_zones            | The availability zones of instance type. |
| tags                          | The tags of vpc.                         |
| vpn_gateway_id                | The ID of the VPN Gateway                |
| vpn_gateway_public_ip_address | The public ip address of the VPN Gateway |
| network_acl_id                | The ID of the network ACL                |
| nat_gateway_id                | The ID of the NAT Gateway                |
| nat_public_ips                | The EIPs of the NAT Gateway              |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
