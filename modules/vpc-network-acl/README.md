# terraform-tencentcloud-vpc-network-acl

Terraform module which creates a **VPC Network ACL (Access Control List)** on an existing TencentCloud VPC.

The following resources are included.

* [VPC Network ACL](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpc_acl)

A Network ACL is a stateless traffic filtering layer for a VPC subnet. This module creates a single `tencentcloud_vpc_acl` and supports both ingress and egress rule sets. The target VPC can be specified directly via `vpc_id`, or looked up by name via the `tencentcloud_vpc_instances` data source using `vpc_name` (when `vpc_id` is not provided).

## Usage

```hcl
module "vpc_network_acl" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-network-acl.git"

  # Identify the target VPC: either by ID ...
  vpc_id = "vpc-xxxxxxxx"

  # ... or by name (the first matched VPC is used when vpc_id is null)
  # vpc_name = "my-vpc"

  network_acl_name = "example-acl"

  network_acl_ingress = [
    "ACCEPT#10.0.0.0/24#80#TCP#ALLOW_WEB",
    "DROP#0.0.0.0/0#ALL#ALL#DROP_ALL"
  ]

  network_acl_egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL#ALLOW_ALL"
  ]

  network_acl_tags = {
    "createdBy" = "Terraform"
  }
}
```

## Rule Format

Each ingress/egress rule is a string of the following format:

```
[action]#[cidr_ip]#[port]#[protocol]#[description]
```

| Field | Description |
|-------|-------------|
| action | `ACCEPT` or `DROP`. |
| cidr_ip | An IP address, network, or CIDR segment (e.g. `10.0.0.0/24`, `0.0.0.0/0`). |
| port | A single port (e.g. `80`), a port range (e.g. `80-90`), or `ALL`. |
| protocol | `TCP`, `UDP`, `ICMP`, or `ALL`. When `protocol` is `ICMP` or `ALL`, `port` must be `ALL`. |
| description | Free-text description; must be in uppercase. |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | The ID of the VPC on which the Network ACL will be created. | string | null | no |
| vpc_name | The name of the VPC to look up (used only when `vpc_id` is null). The first matched VPC is selected. | string | null | no |
| network_acl_name | The name of the Network ACL. | string | n/a | yes |
| network_acl_ingress | Ingress rules. See [Rule Format](#rule-format). | list(string) | [] | no |
| network_acl_egress | Egress rules. See [Rule Format](#rule-format). | list(string) | [] | no |
| network_acl_tags | Additional tags for the Network ACL. | map(string) | null | no |

> Either `vpc_id` or `vpc_name` must be provided so that a target VPC can be resolved.

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-network-acl)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
