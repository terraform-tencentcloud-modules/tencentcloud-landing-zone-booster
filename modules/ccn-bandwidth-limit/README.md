# terraform-tencentcloud-ccn-bandwidth-limit
Terraform module which sets the CCN bandwidth limit on TencentCloud.

This module uses the `tencentcloud_ccn_bandwidth_limit` resource to **limit the bandwidth** of cross-region traffic between a source region and a destination region within a specified CCN instance.

## Usage

```hcl
module "ccn_bandwidth_limit" {
  source = "terraform-tencentcloud-modules/ccn-bandwidth-limit/tencentcloud"

  ccn_id          = "ccn-xxxxxxxx" # ID of the target CCN instance
  src_region      = "ap-guangzhou" # Source region of the bandwidth limit
  dst_region      = "ap-chengdu"   # Destination region of the bandwidth limit
  bandwidth_limit = 100            # Bandwidth limit in Mbps
}
```

## Examples

- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ccn-bandwidth-limit/tree/master/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.136 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.136 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_ccn_bandwidth_limit.limit](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_bandwidth_limit) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | The ID of the CCN instance to which the bandwidth limit applies. | `string` | n/a | yes |
| <a name="input_src_region"></a> [src\_region](#input\_src\_region) | Source region of the bandwidth limit. | `string` | n/a | yes |
| <a name="input_dst_region"></a> [dst\_region](#input\_dst\_region) | Destination region of the bandwidth limit. If the CCN rate limit type is `OUTER_REGION_LIMIT`, this value does not need to be set. | `string` | n/a | yes |
| <a name="input_bandwidth_limit"></a> [bandwidth\_limit](#input\_bandwidth\_limit) | Bandwidth limit value (in Mbps). | `number` | `0` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
