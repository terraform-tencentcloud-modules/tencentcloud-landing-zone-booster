# VPN Gateway CCN Module Examples

本目录包含使用 `tencentcloud-vpn-gateway-ccn` 模块的不同场景示例。

## 示例列表

### 1. Basic VPN Gateway (`basic-vpn-gateway/`)

**场景**: 创建基础的VPN网关，不涉及CCN功能

**特点**:
- 创建标准的IPSEC类型VPN网关
- 需要指定VPC ID
- 不创建或附加CCN
- 适用于简单的VPN连接需求

**使用方式**:
```bash
cd basic-vpn-gateway
terraform init
terraform plan
terraform apply
```

### 2. VPN Gateway with New CCN (`vpn-gateway-with-new-ccn/`)

**场景**: 创建VPN网关并同时创建新的CCN网络

**特点**:
- 创建CCN类型的VPN网关
- 自动创建新的CCN网络
- 自动将VPN网关附加到新创建的CCN
- 适用于需要云联网功能的场景

**使用方式**:
```bash
cd vpn-gateway-with-new-ccn
terraform init
terraform plan
terraform apply
```

### 3. VPN Gateway with Existing CCN (`vpn-gateway-with-existing-ccn/`)

**场景**: 创建VPN网关并附加到现有的CCN网络

**特点**:
- 创建CCN类型的VPN网关
- 使用现有的CCN ID进行附加
- 适用于已有CCN网络的场景
- 支持跨账户CCN附加（通过ccn_uin参数）

**使用方式**:
```bash
cd vpn-gateway-with-existing-ccn
terraform init
terraform plan
terraform apply
```

## 配置说明

### 必需参数

所有示例都需要配置以下参数：
- `vpn_gateway_name`: VPN网关名称
- `bandwidth`: 带宽大小（Mbps）
- `zone`: 可用区

### 可选参数

根据使用场景选择配置：
- `vpc_id`: 仅适用于非CCN类型的VPN网关
- `ccn_id`: 仅适用于附加现有CCN的场景
- `create_ccn`: 是否创建新CCN
- `attach_ccn`: 是否附加CCN

### 注意事项

1. **CCN类型VPN网关**: 当使用CCN类型时，不需要指定`vpc_id`参数
2. **带宽选择**: 支持5,10,20,50,100,200,500,1000 Mbps
3. **计费类型**: 支持预付费(PREPAID)和后付费(POSTPAID_BY_HOUR)
4. **区域限制**: CCN附件需要指定实例区域`instance_region`

## 使用步骤

1. 选择合适的示例目录
2. 修改`main.tf`中的参数值
3. 运行`terraform init`初始化
4. 运行`terraform plan`预览变更
5. 运行`terraform apply`应用配置

## 输出说明

每个示例都包含相关的输出变量，可以通过`terraform output`命令查看创建的资源信息。