# tencentcloud_cfw_nat_firewall_switch 模块

本 Terraform 模块用于通过腾讯云 Provider 管理 CFW NAT 防火墙子网开关（资源：`tencentcloud_cfw_nat_firewall_switch`）。该模块封装了最小必要的参数，便于在工程中统一控制某个子网在特定防火墙实例下的开/关状态。

## 目录结构

模块目录下常见文件与用途：

- `main.tf` — 模块主体，声明 `tencentcloud_cfw_nat_firewall_switch` 资源。
- `variables.tf` — 模块输入变量定义及校验（例如 `enable` 必须为 0 或 1）。
- `outputs.tf` — 模块输出（如资源 `id`）。
- `versions.tf` — provider 与 Terraform 版本约束（如存在）。
- `examples/` — 示例变量文件（`.tfvars`），演示常见使用场景。
- `README.md` — 中文文档（本文件）。
- `README_EN.md` — 英文文档。

修改模块时请同步更新 `variables.tf`、`outputs.tf` 与本 README，以保持文档一致性。

## 简介

该模块直接映射 provider 资源 `tencentcloud_cfw_nat_firewall_switch`，用于对指定 `subnet_id` 在指定 `nat_ins_id`（防火墙实例）下进行开关控制。主要输入如下：

- `enable` (number) — 开关状态，0 表示关闭，1 表示开启。模块会校验该值只能为 0 或 1。
- `nat_ins_id` (string) — 防火墙实例 ID（ForceNew，变更会触发替换）。
- `subnet_id` (string) — 子网 ID（ForceNew，变更会触发替换）。

输出：模块导出资源 `id`（见 `outputs.tf`）。

## 变量（Variables）摘要

完整定义请参见 `variables.tf`。要点：

- `enable`：必须为 0 或 1。
- `nat_ins_id` 与 `subnet_id`：均为必填字符串，且在资源中为 ForceNew（修改时会替换资源）。

示例调用：

```hcl
module "cfw_nat_subnet_switch" {
  source     = "../../modules/tencentcloud-cfw-nat-firewall-switch"
  enable     = 1
  nat_ins_id = "cfwnat-EXAMPLE-1234"
  subnet_id  = "subnet-EXAMPLE-5678"
}
```

## 输出（Outputs）

- `id` — 资源 ID，来自 `tencentcloud_cfw_nat_firewall_switch`。

## 常见示例（`examples/`）

模块目录下的 `examples/` 提供了方便的 `.tfvars` 文件用于快速测试/验证：

1. `enable.tfvars` — 将指定子网在指定防火墙实例下开启（enable=1）。
2. `disable.tfvars` — 将指定子网关闭（enable=0）。
3. `example_custom.tfvars` — 带占位符的自定义示例，便于拷贝修改。

使用示例：

```bash
terraform init
terraform plan -var-file=modules/tencentcloud-cfw-nat-firewall-switch/examples/enable.tfvars
terraform apply -var-file=modules/tencentcloud-cfw-nat-firewall-switch/examples/enable.tfvars
```

注意事项：

- `nat_ins_id` 与 `subnet_id` 在资源中标记为 ForceNew，变更会导致替换，请在修改前确认是否可接受替换行为。
- 请确保当前腾讯云账号和凭证对指定防火墙实例具有管理权限。
- 示例中的 ID 为占位符，请替换为真实 ID 再执行 `apply`。

如需我把 `versions.tf` 的 provider 约束摘入 README 或创建一个完整的 caller 示例（`examples/complete/`，含 `main.tf`），我可以继续补充。
