# terraform-tencentcloud-controlcenter-account-baseline-batch-apply

Terraform module which batch applies Control Center account baselines to member accounts (`tencentcloud_batch_apply_account_baselines`).

## Usage

```hcl
module "account_baselines" {
  source  = "terraform-tencentcloud-modules/controlcenter-account-baseline-batch-apply/tencentcloud"

  member_uin_list = [
    10037652245,
    10037652240,
  ]

  baseline_config_items = [
    {
      identifier    = "TCC-AF_SHARE_IMAGE"
      configuration = "{\"Images\":[{\"Region\":\"ap-guangzhou\",\"ImageId\":\"img-mcdsiqrx\",\"ImageName\":\"demo1\"}, {\"Region\":\"ap-guangzhou\",\"ImageId\":\"img-esxgkots\",\"ImageName\":\"demo2\"}]}"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| member_uin_list | Member account UIN, which is also the UIN of the account to which the baseline is applied. | list(number) | n/a | yes |
| baseline_config_items | List of baseline item configuration information. Each item has an `identifier` (unique Account Factory baseline item identifier) and an optional `configuration` (JSON string; parameters vary per baseline item). | list(object({ identifier = string, configuration = optional(string) })) | n/a | yes |

## Outputs

This module does not export any outputs. `outputs.tf` is intentionally empty.

## Examples

See the `Usage` section above for a complete example.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-controlcenter-account-baseline-batch-apply)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.