# tencentcloud-private-dns-end-points

This Terraform component creates Tencent Cloud Private DNS end points.

Private DNS end points are used by forwarding rules to route DNS queries between Private DNS and external networks.

## Usage

```hcl
module "private_dns_end_points" {
  source = "./tc-modules/components/network/private-dns/end-points"

  end_points = {
    default = {
      end_point_name       = "example-private-dns-endpoint"
      end_point_region     = "ap-guangzhou"
      end_point_service_id = "vpcsvc-xxxxxxxx"
      ip_num               = 1
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
| tencentcloud_private_dns_end_point.end_points | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| end_points | Map of Private DNS end point configurations. | map(object({ end_point_name = string, end_point_region = string, end_point_service_id = string, ip_num = optional(number, 1) })) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| end_point_ids | Map of end point keys to their IDs |
| end_points | Complete Private DNS end point resource objects |
