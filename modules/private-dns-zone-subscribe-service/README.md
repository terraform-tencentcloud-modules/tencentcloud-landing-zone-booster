# tencentcloud-private-dns-zone-subscribe-service

A Terraform module that subscribes to (enables) the Tencent Cloud Private DNS zone service (`tencentcloud_subscribe_private_zone_service`). This must be enabled before you can create Private DNS zones and related resources.

## Usage

```hcl
module "private_dns_zone_service_subscribe" {
  source = "terraform-tencentcloud-modules/private-dns-zone-subscribe-service/tencentcloud"

  enable_private_zone_service = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| tencentcloud | >= 1.82.70 |

## Providers

| Name | Version |
|------|---------|
| tencentcloud | >= 1.82.70 |

## Resources

| Name | Type |
|------|------|
| tencentcloud_subscribe_private_zone_service.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_private_zone_service | Whether to enable private zone service subscription. | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| private_zone_service_enabled | Whether private zone service is enabled. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-private-dns-zone-subscribe-service)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
