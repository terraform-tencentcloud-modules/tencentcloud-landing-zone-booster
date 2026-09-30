# terraform-tencentcloud-tco-organization-org-share-unit

Terraform module which creates an Organization share unit and attaches members and resources to it on TencentCloud.

The following resources are included.

* [Organization Org Share Unit](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_share_unit)
* [Organization Org Share Unit Member](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_share_unit_member)
* [Organization Org Share Unit Resource](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_share_unit_resource)

## Usage

```hcl
variable "unit_resources" {
  type = map(object({
    type                = string
    product_resource_id = string
  }))
  default = {
    res1 = {
      type                = "VPC"
      product_resource_id = "vpc-xxxxxxxx"
    }
  }
}

module "organization_org_share_unit" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-share-unit.git"

  create           = true
  name             = "example-share-unit"
  area             = "ap-guangzhou"
  description      = "Example share unit"
  unit_member_uins = ["100000001", "100000002"]
  unit_resources   = var.unit_resources
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create the share unit and related resources. | bool | true | no |
| name | The name of the share unit. | string | "" | no |
| area | The area of the share unit. | string | "" | no |
| description | The description of the share unit. | string | "" | no |
| unit_member_uins | List of member UINs to be added to the share unit. | list(string) | [] | no |
| unit_resources | A map of resources to be added to the share unit. Each item contains `type` (resource type) and `product_resource_id` (product resource ID). | map(object({ type = string, product_resource_id = string })) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| unit_id | The ID of the created share unit. |
| unit_name | The name of the created share unit. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-share-unit)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
