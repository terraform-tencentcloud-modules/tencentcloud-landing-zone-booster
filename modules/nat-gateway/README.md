## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_nat_gateway.nat](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/nat_gateway) | resource |
| [tencentcloud_route_table_entry.route_entry](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/route_table_entry) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | whether create nat gateway or use an existed one | `bool` | `true` | no |
| <a name="input_nat_gateway_bandwidth"></a> [nat\_gateway\_bandwidth](#input\_nat\_gateway\_bandwidth) | bandwidth of NAT Gateway | `number` | `100` | no |
| <a name="input_nat_gateway_concurrent"></a> [nat\_gateway\_concurrent](#input\_nat\_gateway\_concurrent) | bandwidth of NAT Gateway | `number` | `1000000` | no |
| <a name="input_nat_gateway_id"></a> [nat\_gateway\_id](#input\_nat\_gateway\_id) | used when `create_nat_gateway` is false | `string` | `""` | no |
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | nat gateway name | `string` | `""` | no |
| <a name="input_nat_public_ips"></a> [nat\_public\_ips](#input\_nat\_public\_ips) | List of EIPs to be used for `nat_gateway` | `list(string)` | n/a | yes |
| <a name="input_routable_attachments"></a> [routable\_attachments](#input\_routable\_attachments) | to which route tables should this nat gateway attach | <pre>map(object({<br>    route_table_id = string<br>    destination_cidr = optional(string, "0.0.0.0/0")<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id of vpc where nat gateway created | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | n/a |
