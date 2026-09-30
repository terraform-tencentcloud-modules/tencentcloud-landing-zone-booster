# terraform-tencentcloud-tag

Terraform module which creates tags on TencentCloud.

The following resources are included.

* [Tag](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/tag)

## Usage

```hcl
variable "tags" {
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    {
      key   = "env"
      value = "prod"
    },
    {
      key   = "owner"
      value = "team-a"
    }
  ]
}

module "tag" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tag.git"

  tags = var.tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | A list of tags to be created, each with a `key` and a `value`. | list(object({ key = string, value = string })) | n/a | yes |

## Outputs

No outputs are exported.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tag)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
