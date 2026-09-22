# tencentcloud-private-dns-extend-end-point

This Terraform component creates Tencent Cloud Private DNS extend end points.

Private DNS extend end points support one or more forward IP configurations and can be used by Private DNS forwarding rules to route DNS queries through CLB or CCN access paths.

## Usage

```hcl
module "private_dns_extend_end_point" {
  source = "./tc-modules/components/network/private-dns/extend-end-point"

  extend_end_points = {
    default = {
      end_point_name   = "example-private-dns-extend-endpoint"
      end_point_region = "ap-guangzhou"

      forward_ip = [
        {
          access_type = "CLB"
          host        = "10.0.0.10"
          port        = 53
          vpc_id      = "vpc-xxxxxxxx"
        }
      ]
    }
  }
}
```

## Usage with Multiple Forward IPs

```hcl
module "private_dns_extend_end_point" {
  source = "./tc-modules/components/network/private-dns/extend-end-point"

  extend_end_points = {
    ccn_endpoint = {
      end_point_name   = "example-ccn-extend-endpoint"
      end_point_region = "ap-guangzhou"

      forward_ip = [
        {
          access_type       = "CCN"
          hosts             = ["10.0.1.10", "10.0.1.11"]
          port              = 53
          vpc_id            = "vpc-xxxxxxxx"
          access_gateway_id = "ccn-xxxxxxxx"
        }
      ]
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| tencentcloud | >= 1.82.70 |

## Providers

| Name | Version |
|------|---------|
| tencentcloud | >= 1.82.70 |

## Resources

| Name | Type |
|------|------|
| tencentcloud_private_dns_extend_end_point.extend_end_points | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| extend_end_points | Map of Private DNS extend end point configurations. Each item supports multiple forward IP settings. | map(object({ end_point_name = string, end_point_region = string, forward_ip = list(object({ access_type = string, host = optional(string), hosts = optional(set(string)), port = number, vpc_id = string, access_gateway_id = optional(string) })) })) | {} | no |

### `extend_end_points` Object

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| end_point_name | Extend end point name. | string | yes |
| end_point_region | Region where the extend end point is created. | string | yes |
| forward_ip | Forward IP configurations. | list(object) | yes |

### `forward_ip` Object

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| access_type | Access type. Supported values include `CLB` and `CCN`. | string | yes |
| host | Single forward IP address. Mutually exclusive with `hosts`. | string | no |
| hosts | Set of forward IP addresses. Mutually exclusive with `host`. | set(string) | no |
| port | Forward port number. Valid range is 1 to 65535. | number | yes |
| vpc_id | VPC ID. | string | yes |
| access_gateway_id | CCN ID. Required when `access_type` is `CCN`. | string | no |

## Outputs

| Name | Description |
|------|-------------|
| extend_end_point_ids | Map of extend end point keys to their IDs |
| extend_end_points | Complete Private DNS extend end point resource objects |
