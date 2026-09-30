# tencentcloud-private-dns-forward-rule

A Terraform module that creates a TencentCloud Private DNS forwarding rule (`tencentcloud_private_dns_forward_rule`). A forwarding rule binds a Private DNS zone to an outbound/extend endpoint and defines the direction of DNS forwarding (`rule_type`).

## Usage

```hcl
module "private_dns_forward_rule" {
  source = "terraform-tencentcloud-modules/private-dns-forward-rule/tencentcloud"

  create                 = true
  dns_forward_rule_name  = "my-forward-rule"
  rule_type              = "DOWN" # "DOWN": from cloud to off-cloud; "UP": from off-cloud to cloud
  private_dns_zone_id    = "zone-xxxxxxxx"
  dns_end_point_id       = "vpc-endpoint-xxxxxxxx"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create | Whether to create the forwarding rule or not. | bool | true | no |
| private_dns_zone_id | The ID of the Private DNS zone the forwarding rule belongs to (used as `zone_id`). | string | "" | no |
| dns_forward_rule_name | The name of the forwarding rule. | string | "" | no |
| rule_type | The forwarding rule type. `DOWN`: from cloud to off-cloud; `UP`: from off-cloud to cloud. | string | "UP" | no |
| dns_end_point_id | The ID of the endpoint the rule forwards through. | string | "" | no |

## Outputs

| Name | Description |
|------|-------------|
| dns_forward_rule_name | The name of the Private DNS forwarding rule. |
| dns_forward_rule_id | The ID of the Private DNS forwarding rule. Empty string (`""`) when `create` is false. |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| tencentcloud | >= 1.81.139 |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-private-dns-forward-rule)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
