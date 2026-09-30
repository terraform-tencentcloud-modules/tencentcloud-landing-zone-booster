# terraform-tencentcloud-tco-organization-service-assign

Terraform module which assigns (delegates) Organization services to member accounts as delegated administrators on TencentCloud.

The following resources are included.

* [Organization Service Assign](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_service_assign)

It also reads the available organization services via the `tencentcloud_organization_services` data source to resolve the service ID by product name, and only assigns a service when it still has available quota (`member_num < can_assign_count`).

## Usage

```hcl
variable "service_assign_list" {
  type = list(object({
    member_uin   = number # Member UIN.
    service_name = string # Organization service product name, e.g. "Cloud Audit", "Tag", etc.
  }))
  default = [
    {
      member_uin   = 1000001
      service_name = "Cloud Audit"
    },
    {
      member_uin   = 1000002
      service_name = "Tag"
    }
  ]
}

module "organization_service_assign" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-service-assign.git"

  management_scope  = 1
  service_assign_list = var.service_assign_list
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| management_scope | Management scope of the delegated admin. `1`: all members, `2`: partial members. | number | 1 | no |
| service_assign_list | A list of service assignments. Each item contains: `member_uin` (member UIN) and `service_name` (organization service product name, used to resolve the `service_id`). | list(object({ member_uin = number, service_name = string })) | n/a | yes |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-service-assign)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
