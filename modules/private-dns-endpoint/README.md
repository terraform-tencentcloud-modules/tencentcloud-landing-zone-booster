# tencentcloud-private-dns-endpoint

A Terraform module that creates a TencentCloud Private DNS endpoint (`tencentcloud_private_dns_end_point`). A Private DNS endpoint is used to access Private DNS resolution over a specified service (e.g. a VPC endpoint service) in a given region, with a configurable number of IP addresses.

## Usage

```hcl
module "private_dns_endpoint" {
  source = "terraform-tencentcloud-modules/private-dns-endpoint/tencentcloud"

  end_point_name       = "my-dns-endpoint"
  end_point_service_id = "vpcsvc-xxxxxxxx"
  end_point_region     = "ap-guangzhou"
  ip_num               = 2
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| end_point_name | The name of the Private DNS endpoint. | string | "" | no |
| end_point_service_id | The service ID (e.g. VPC endpoint service ID) associated with the Private DNS endpoint. | string | "" | no |
| end_point_region | The region for the Private DNS endpoint. | string | "" | no |
| ip_num | The number of IPs for the endpoint. | number | 1 | no |

## Outputs

| Name | Description |
|------|-------------|
| dns_end_point_id | The ID of the Private DNS endpoint. |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| tencentcloud | >= 1.81.158 |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-private-dns-endpoint)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
