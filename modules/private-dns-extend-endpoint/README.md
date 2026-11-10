# tencentcloud-private-dns-extend-endpoint

A Terraform module that creates a TencentCloud Private DNS outbound (extend) endpoint (`tencentcloud_private_dns_extend_end_point`). An outbound endpoint forwards DNS queries to external/remote DNS servers (e.g. via a CLB or a CCN-connected network) according to the configured forwarding targets (`forward_ip`).

## Usage

```hcl
module "private_dns_extend_endpoint" {
  source = "terraform-tencentcloud-modules/private-dns-extend-endpoint/tencentcloud"

  create           = true
  end_point_name   = "my-outbound-endpoint"
  end_point_region = "ap-guangzhou"

  # Example 1: forward via a CLB (single target)
  forwards = [
    {
      access_type = "CLB"
      host        = "10.0.0.10"
      hosts       = null
      port        = 53
      vpc_id      = "vpc-xxxxxxxx"
      access_gateway_id = null
    },
    # Example 2: forward via CCN (one or more "ip:port" targets)
    # {
    #   access_type       = "CCN"
    #   host              = null
    #   hosts             = ["10.1.0.10:53", "10.1.0.11:53"]
    #   port              = 53
    #   vpc_id            = "vpc-xxxxxxxx"
    #   access_gateway_id = "ccn-xxxxxxxx"
    # }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create | Whether to create the outbound endpoint or not. | bool | true | no |
| end_point_name | The name of the Private DNS outbound endpoint. | string | "" | no |
| end_point_region | The region of the endpoint, which should be consistent with the region of the endpoint service. | string | "" | no |
| forwards | Forwarding targets of the Private DNS outbound endpoint. Each entry maps to one `forward_ip` block. `access_type = "CLB"`: single target via `host` + `port` (no `hosts`/`access_gateway_id`). `access_type = "CCN"`: one or more targets via `hosts` (`"ip:port"` strings) + `access_gateway_id` (a CCN instance ID starting with `ccn-`). At least one entry is required when `create` is true. | list(object({ access_type = string, host = optional(string), hosts = optional(set(string)), port = number, vpc_id = string, access_gateway_id = optional(string) })) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| dns_end_point_name | The name of the Private DNS outbound endpoint. |
| dns_end_point_id | The ID of the Private DNS outbound endpoint. Empty string (`""`) when `create` is false. |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.15 |
| tencentcloud | >= 1.83.10 |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-private-dns-extend-endpoint)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
