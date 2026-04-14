# TencentCloud VPN Gateway v2 Module

该模块用于创建腾讯云VPN网关v2版本，支持更多功能和参数。

## 功能特性

- 支持所有VPN网关类型：IPSEC、SSL、CCN、SSL_CCN
- 支持BGP ASN配置
- 支持CDC实例ID
- 导出完整的VPN网关属性
- 支持预付费和后付费计费模式

## 使用示例

```hcl
module "vpn_gateway_v2" {
  source = "./modules/tencentcloud-vpn-gateway-v2"
  
  vpn_gateway_name = "my-vpn-gateway-v2"
  bandwidth        = 100
  type             = "CCN"
  zone             = "ap-guangzhou-3"
  
  # v2新增参数
  bgp_asn          = 65000
  cdc_id           = "cdc-xxxxxx"
  
  vpn_tags = {
    Environment = "production"
    Project     = "vpn-project"
  }
}
```

## 输入参数

| 名称 | 描述 | 类型 | 必需 | 默认值 |
|------|------|------|------|--------|
| create_vpn_gateway | 是否创建VPN网关 | bool | 否 | true |
| vpn_gateway_name | VPN网关名称(1-60字符) | string | 是 | - |
| bandwidth | 公网带宽(Mbps) | number | 是 | - |
| type | 网关类型 | string | 否 | IPSEC |
| zone | 可用区 | string | 否 | ap-guangzhou-3 |
| vpc_id | VPC ID | string | 否 | null |
| vpc_instance_name | VPC实例名称 | string | 否 | null |
| charge_type | 计费类型 | string | 否 | POSTPAID_BY_HOUR |
| prepaid_period | 预付费周期 | number | 否 | null |
| prepaid_renew_flag | 续费标志 | string | 否 | null |
| max_connection | SSL VPN最大连接数 | number | 否 | null |
| vpn_tags | 标签 | map(string) | 否 | {} |
| bgp_asn | BGP ASN | number | 否 | null |
| cdc_id | CDC实例ID | string | 否 | null |

## 输出参数

| 名称 | 描述 |
|------|------|
| vpn_instance_id | VPN网关ID |
| create_time | 创建时间 |
| expired_time | 过期时间 |
| is_address_blocked | IP是否被阻断 |
| new_purchase_plan | 新购买计划 |
| public_ip_address | 公网IP地址 |
| restrict_state | 限制状态 |
| state | 网关状态 |

## 注意事项

- CCN类型VPN网关不需要指定VPC ID
- SSL类型VPN网关需要指定max_connection参数
- 预付费模式需要指定prepaid_period和prepaid_renew_flag
