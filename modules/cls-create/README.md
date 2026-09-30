# terraform-tencentcloud-cls-create

A terraform module used to activate (open) the TencentCloud CLS (Cloud Log Service) for the current account. It creates a single `tencentcloud_cls_open_service_operation` resource and exposes the activation status.

## Examples

```hcl
provider "tencentcloud" {
  region = "ap-shanghai"
}

module "cls_create" {
  source = "terraform-tencentcloud-modules/cls-create/tencentcloud"
}
```

## Inputs

This module has no input variables.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| - | - | - | - | - |

## Outputs

| Name        | Description                          |
|-------------|--------------------------------------|
| cls_status  | The activation status of CLS service.  |

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
