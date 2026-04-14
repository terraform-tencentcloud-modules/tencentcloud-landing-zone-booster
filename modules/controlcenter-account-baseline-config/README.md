# terraform-tencentcloud-ccn
Terraform module which create a controlcenter batch apply account baselines

## Usage

```hcl
module "account_baselines" {
  source  = "terraform-tencentcloud-modules/controlcenter/tencentcloud"

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

## Examples