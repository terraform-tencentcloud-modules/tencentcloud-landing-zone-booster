
# tencentcloud_cfw_vpc_firewall_switch 模块

本 Terraform 模块用于通过腾讯云 Provider 管理 CFW（云防火墙）VPC 防火墙开关（资源：`tencentcloud_cfw_vpc_firewall_switch`）。该模块封装了最小必要的参数，便于在工程中复用与统一管理防火墙开/关状态。

## 说明

该模块非常轻量，包含三个必需输入变量：

- `enable`：开关状态（整数，0 = 关闭，1 = 开启）。
- `switch_id`：防火墙开关 ID（字符串，见腾讯云控制台或 API 返回）。
- `vpc_ins_id`：防火墙实例 ID（字符串）。

模块会创建/管理资源 `tencentcloud_cfw_vpc_firewall_switch`，并导出资源 `id`。

在对模块进行改动（例如新增变量、变更输出或增加示例）时，请同时更新相应的 `variables.tf` / `outputs.tf` 与文档，以保持一致性。

## 目录结构

模块目录下常见文件与用途：

- `main.tf` — 模块主体，声明 `tencentcloud_cfw_vpc_firewall_switch` 资源。
- `variables.tf` — 模块输入变量定义与说明（类型、校验等）。
- `outputs.tf` — 模块导出输出（例如资源 `id`）。
- `versions.tf` — provider 与 Terraform 版本约束（如存在）。
- `examples/` — 示例调用与变量文件（`.tfvars`），演示常见使用场景。
- `README.md` — 中文文档（本文件）。
- `README_EN.md` — 英文文档。

## 变量（Variables）

以下变量来自 `variables.tf`，均为必需项：

- `enable` (number) — 必填。开关状态：0 关闭，1 开启。模块会校验该值只能是 0 或 1。
- `switch_id` (string) — 必填。防火墙 switch 的 ID（注意：此变量在资源中为 ForceNew，变更会导致替换）。
- `vpc_ins_id` (string) — 必填。防火墙实例 ID（ForceNew）。

示例：

```hcl
module "cfw_switch" {
  source     = "../../modules/tencentcloud-cfw-vpc-firewall-switch"
  enable     = 1
  switch_id  = "cfw-switch-xxxx"
  vpc_ins_id = "vpc-ins-xxxx"
}
```

## 输出（Outputs）

- `id` — 资源 ID，来自 `tencentcloud_cfw_vpc_firewall_switch` 资源。

## 常见用例（示例文件在 `examples/` 目录下）

1. 开启防火墙开关（启用） — `examples/enable.tfvars`
2. 关闭防火墙开关（停用） — `examples/disable.tfvars`
3. 带占位符的自定义示例 — `examples/example_custom.tfvars`

每个示例都是一个 `.tfvars` 文件，方便在 `terraform plan/apply` 时传入 `-var-file` 参数进行验证与执行。

## 使用与本地验证

1. 在调用目录中创建 `main.tf` 并引用本模块（参见上方示例）。
2. 运行：

```bash
terraform init
terraform plan -var-file=examples/enable.tfvars
terraform apply -var-file=examples/enable.tfvars
```

注意事项：

- `switch_id` 与 `vpc_ins_id` 在模块定义中属于强制重新创建（ForceNew），若需要修改请先确认是否允许替换资源。
- 请确保使用的 Tencent Cloud 账户/凭证拥有对防火墙实例管理的权限。

## 贡献与维护

若需要添加更多输出或参数（例如导出更多属性、增加可选项），请修改 `variables.tf` / `outputs.tf` 并同步更新本 README。
