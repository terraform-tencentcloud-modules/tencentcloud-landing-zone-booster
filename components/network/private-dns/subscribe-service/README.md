# tencentcloud-private-dns-zone-service-subscribe

This Terraform module subscribes to the Tencent Cloud Private DNS service.

## Usage

```hcl
module "private_dns_zone_service_subscribe" {
  source = "./tc-modules/modules/private-dns-zone-service-subscribe"

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
| enable_private_zone_service | Whether to enable private zone service subscription | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| private_zone_service_enabled | Whether private zone service is enabled |
