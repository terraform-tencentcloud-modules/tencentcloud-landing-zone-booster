# tencentcloud-private-dns-records

A Terraform module that manages TencentCloud Private DNS records (`tencentcloud_private_dns_record`) within a Private DNS zone. Records are provided as a map keyed by `sub_domain`, allowing you to create multiple records at once.

## Usage

```hcl
module "private_dns_records" {
  source = "terraform-tencentcloud-modules/private-dns-records/tencentcloud"

  create               = true
  private_dns_zone_id = "zone-xxxxxxxx"

  records = {
    www = {
      record_type  = "A"
      record_value = "1.1.1.1"
      sub_domain   = "www"
      ttl          = 600
      weight       = 10
      mx           = 5 # valid values: 5, 10, 15, 20, 30, 40, 50
    }
    api = {
      record_type  = "AAAA"
      record_value = "2001:db8::1"
      sub_domain   = "api"
      ttl          = 300
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create | Whether to create the records or not. | bool | true | no |
| private_dns_zone_id | The ID of the Private DNS zone the records belong to (used as `zone_id`). | string | "" | no |
| records | A map of DNS records to create. The map key is the `sub_domain`. Each value supports `record_type` (default `A`), `record_value` (default `""`), `sub_domain` (default `""`), `ttl` (default `600`), `weight` (default `null`) and `mx` (default `null`; valid values: 5, 10, 15, 20, 30, 40, 50). | map(object({ record_type = optional(string), record_value = optional(string), sub_domain = optional(string), ttl = optional(number), weight = optional(number), mx = optional(number) })) | see `variables.tf` (an `example` entry) | no |

## Outputs

| Name | Description |
|------|-------------|
| records | The map of records config that was provided as input. |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| tencentcloud | >= 1.81.106 |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-private-dns-records)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
