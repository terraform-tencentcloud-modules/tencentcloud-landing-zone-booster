# tencentcloud_cfw_nat_instance 模块

该 Terraform 模块用于在腾讯云上创建和管理云防火墙（CFW）NAT 实例（资源：`tencentcloud_cfw_nat_instance`）。模块封装了常用参数与校验，便于在不同环境中复用与统一管理 NAT 型防火墙实例。

## 目录结构

模块目录下常见文件与用途：

- `main.tf` — 模块主体，声明 `tencentcloud_cfw_nat_instance` 资源及动态块。
- `variables.tf` — 模块输入变量定义与说明（类型、默认值、校验规则）。
- `outputs.tf` — 模块导出输出（例如资源 `id`）。
- `versions.tf` — provider 与 Terraform 版本约束（如存在）。
- `examples/` — 示例变量文件（`.tfvars`），演示常见使用场景。
- `README.md` — 中文文档（本文件）。
- `README_EN.md` — 英文文档。

在对模块进行改动（例如新增变量、变更输出）时，请同时更新 `variables.tf` / `outputs.tf` 与本 README，以保持一致性。

## 简介

模块映射以下重要字段：

- `mode` (number) — 模式：1 表示接入模式(access mode)，0 表示新模式(new mode)。该变量被校验为 0 或 1。
- `name` (string) — 实例名称。
- `width` (number) — 带宽（单位取决于腾讯云 API，通常为 Mbps）。
- `zone_set` (set(string)) — 可用区集合，至少一个。
- `cross_a_zone` (number, optional) — 是否开启跨可用区/异地灾备（0/1），默认 0。
- `nat_gw_list` (set(string), optional) — 当为接入模式时，可填写关联的 NAT 网关列表（至少与 `new_mode_items` 之一传入）。
- `new_mode_items` (list(object), optional) — 新模式下的参数列表，每项包含 `eips`（弹性公网 IP 集合）与 `vpc_list`（VPC 列表）。

模块会创建 `tencentcloud_cfw_nat_instance` 资源并导出 `id`。

## 变量（Variables）

参见 `variables.tf` 中的定义。要点摘要：

- `mode`：必须为 0 或 1。
- `name`、`width`、`zone_set`：必填。
- `cross_a_zone`：可选，默认 0。
- `nat_gw_list` / `new_mode_items`：至少传递其中之一（用于不同模式下的网络接入配置）。

示例最小调用（引用模块）：

```hcl
module "cfw_nat" {
  source = "../../modules/tencentcloud-cfw-nat-instance"
  mode   = 0
  name   = "example-cfw-nat"
  width  = 100
  zone_set = ["ap-guangzhou-1"]
  new_mode_items = [
    {
      eips = ["1.2.3.4"]
      vpc_list = ["vpc-xxx"]
    }
  ]
}
```

## 输出（Outputs）

- `id` — 资源 ID，来自 `tencentcloud_cfw_nat_instance`。

## 常见示例（examples/）

模块目录下的 `examples/` 包含若干 `.tfvars` 示例：

1. `new_mode.tfvars` — 使用新模式（mode=0），通过 `new_mode_items` 指定 EIP 与 VPC 列表。
2. `access_mode.tfvars` — 使用接入模式（mode=1），通过 `nat_gw_list` 指定接入的 NAT 网关。
3. `cross_zone.tfvars` — 示例启用跨可用区（`cross_a_zone=1`）。
4. `mixed.tfvars` — 组合示例（多个可用区、较大带宽）。

使用示例：

```bash
terraform init
terraform plan -var-file=modules/tencentcloud-cfw-nat-instance/examples/new_mode.tfvars
terraform apply -var-file=modules/tencentcloud-cfw-nat-instance/examples/new_mode.tfvars
```

## 注意事项

- `mode` 影响需要传入的参数：接入模式通常需指定 `nat_gw_list`，新模式需通过 `new_mode_items` 填写 `eips` 与 `vpc_list`。
- 请确保传入的 `zone_set` 与账户/地域支持一致。
- 如果需要将敏感信息或受管资源 ID（如 EIP/ VPC）从其他模块传入，建议使用变量引用或远程状态引用的方式。

如需我把 `versions.tf` 的 provider 约束摘入 README 或添加一个完整的 caller 示例（含 `main.tf`），告诉我即可。
