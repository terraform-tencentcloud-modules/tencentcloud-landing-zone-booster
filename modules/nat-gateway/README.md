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
| [tencentcloud_nat_gateway.nat_gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/nat_gateway) | resource |
| [tencentcloud_nat_gateway_flow_monitor.nat_flow_monitor](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/nat_gateway_flow_monitor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of vpc where nat gateway created | `string` | n/a | yes |
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | Nat gateway name | `string` | n/a | yes |
| <a name="input_nat_gateway_zone"></a> [nat\_gateway\_zone](#input\_nat\_gateway\_zone) | Nat gateway zone | `string` | `null` | no |
| <a name="input_nat_gateway_eips"></a> [nat\_gateway\_eips](#input\_nat\_gateway\_eips) | EIP IP address set bound to the gateway. The value of at least 1 and at most 10 if do not apply for a whitelist. | `list(string)` | `[]` | no |
| <a name="input_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#input\_nat\_gateway\_public\_ips) | List of EIPs to be used for `nat_gateway` | `list(string)` | `[]` | no |
| <a name="input_nat_product_version"></a> [nat\_product\_version](#input\_nat\_product\_version) | 1: traditional NAT, 2: standard NAT, default value is 1. | `number` | `1` | no |
| <a name="input_nat_gateway_bandwidth"></a> [nat\_gateway\_bandwidth](#input\_nat\_gateway\_bandwidth) | The maximum public network output bandwidth of NAT gateway (unit: Mbps). Valid values: 20, 50, 100, 200, 500, 1000, 2000, 5000. Default is 100. When nat_product_version is 2 (standard NAT), this parameter is not needed and defaults to 5000. | `number` | `100` | no |
| <a name="input_nat_gateway_concurrent"></a> [nat\_gateway\_concurrent](#input\_nat\_gateway\_concurrent) | The upper limit of concurrent connections of NAT gateway. Valid values: 1000000, 3000000, 10000000. Default is 1000000. When nat_product_version is 2 (standard NAT), this parameter is not needed and defaults to 2000000. | `number` | `1000000` | no |
| <a name="input_stock_public_ip_addresses_bandwidth_out"></a> [stock\_public\_ip\_addresses\_bandwidth\_out](#input\_stock\_public\_ip\_addresses\_bandwidth\_out) | The elastic public IP bandwidth value (unit: Mbps) for binding NAT gateway. When not set, it defaults to the bandwidth value of the elastic public IP, and for some users defaults to the bandwidth limit of their EIP type. | `number` | `null` | no |
| <a name="input_enable_flow_monitor"></a> [enable\_flow\_monitor](#input\_enable\_flow\_monitor) | Whether to enable flow monitor. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | The ID of the NAT Gateway |
