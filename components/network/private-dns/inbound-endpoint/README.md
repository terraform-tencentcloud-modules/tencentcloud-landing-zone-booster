# tencentcloud-private-dns-inbound-endpoint

This Terraform component creates Tencent Cloud Private DNS inbound endpoints.

Private DNS inbound endpoints allow DNS queries from external networks or connected VPC environments to be forwarded into Tencent Cloud Private DNS.

## Usage

```hcl
module "private_dns_inbound_endpoint" {
  source = "./tc-modules/components/network/private-dns/inbound-endpoint"

  inbound_endpoints = {
    default = {
      endpoint_region = "ap-guangzhou"
      endpoint_name   = "example-private-dns-inbound-endpoint"
      endpoint_vpc    = "vpc-xxxxxxxx"

      subnet_ip = [
        {
          subnet_id = "subnet-xxxxxxxx"
        }
      ]
    }
  }
}
```

## Usage with Specified Subnet VIPs

```hcl
module "private_dns_inbound_endpoint" {
  source = "./tc-modules/components/network/private-dns/inbound-endpoint"

  inbound_endpoints = {
    primary = {
      endpoint_region = "ap-guangzhou"
      endpoint_name   = "example-private-dns-inbound-endpoint"
      endpoint_vpc    = "vpc-xxxxxxxx"

      subnet_ip = [
        {
          subnet_id  = "subnet-xxxxxxxx"
          subnet_vip = "10.0.1.10"
        },
        {
          subnet_id  = "subnet-yyyyyyyy"
          subnet_vip = "10.0.2.10"
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
| tencentcloud_private_dns_inbound_endpoint.inbound_endpoints | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| inbound_endpoints | Map of Private DNS inbound endpoint configurations. | map(object({ endpoint_region = string, endpoint_name = string, endpoint_vpc = string, subnet_ip = list(object({ subnet_id = string, subnet_vip = optional(string) })) })) | {} | no |

### `inbound_endpoints` Object

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| endpoint_region | Region where the inbound endpoint is created. | string | yes |
| endpoint_name | Inbound endpoint name. | string | yes |
| endpoint_vpc | VPC ID for the inbound endpoint. | string | yes |
| subnet_ip | Subnet IP configurations. At least one item is required for each inbound endpoint. | list(object) | yes |

### `subnet_ip` Object

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| subnet_id | Subnet ID. | string | yes |
| subnet_vip | Subnet VIP address. If omitted, the IP address is automatically assigned. | string | no |

## Outputs

| Name | Description |
|------|-------------|
| inbound_endpoint_ids | Map of inbound endpoint keys to their IDs |
| inbound_endpoints | Complete Private DNS inbound endpoint resource objects |
