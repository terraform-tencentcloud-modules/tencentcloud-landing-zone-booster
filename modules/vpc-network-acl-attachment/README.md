# terraform-tencentcloud-vpc-network-acl-attachment

Terraform module which associates a **VPC subnet** with an existing **VPC Network ACL (Access Control List)** on TencentCloud.

The following resources are included.

* [VPC ACL Attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpc_acl_attachment)

This module binds a subnet to a pre-created Network ACL so that the ACL's stateless ingress/egress rules are applied to the subnet's traffic.

## Usage

```hcl
module "vpc_network_acl_attachment" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-network-acl-attachment.git"

  network_acl_id = "acl-xxxxxxxx"  # ID of an existing Network ACL
  vpc_subnet_id  = "subnet-xxxxxxxx"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network_acl_id | The ID of the existing Network ACL to attach the subnet to. | string | n/a | yes |
| vpc_subnet_id | The ID of the subnet to be attached to the Network ACL. | string | n/a | yes |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc-network-acl-attachment)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | > 1.18.1 |
