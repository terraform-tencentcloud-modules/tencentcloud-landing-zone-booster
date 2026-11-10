# terraform-tencentcloud-controlcenter-account-baseline-config

Terraform module which creates a Control Center Account Factory baseline configuration (`tencentcloud_controlcenter_account_factory_baseline_config`). Optionally it can create the required service-linked role used by Control Center.

## Usage

```hcl
module "account_baseline_config" {
  source  = "terraform-tencentcloud-modules/controlcenter-account-baseline-config/tencentcloud"

  create_cam_strategy = true # Create the service-linked role (set false if already enabled via the console)

  baseline_name = "tf-baseline"

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
| create_cam_strategy | Specify whether to create the Control Center service-linked role. Set to `false` if you have already enabled it via the TencentCloud Console. | bool | false | no |
| baseline_name | Baseline name, which must be unique. Supports only English letters, numbers, Chinese characters, and symbols `@`, `&`, `_`, `[]`, `-`. Combination of 1-25 Chinese or English characters. | string | n/a | yes |
| baseline_config_items | Baseline configuration (overwrite update). Query existing baseline configurations via `controlcenter:GetAccountFactoryBaseline`, and supported baseline lists via `controlcenter:ListAccountFactoryBaselineItems`. | list(object({ identifier = string, configuration = string })) | n/a | yes |
| tags | Tags. | map(string) | { created_by = "terraform" } | no |

## Outputs

This module does not export any outputs. `outputs.tf` is intentionally empty.

## Examples

See the `Usage` section above for a complete example.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-controlcenter-account-baseline-config)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.