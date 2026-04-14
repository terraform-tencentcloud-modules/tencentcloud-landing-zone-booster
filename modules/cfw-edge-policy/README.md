# tencentcloud_cfw_nat_policy 模块

该 Terraform 模块用于在腾讯云上创建和管理 CFW NAT 策略（资源：`tencentcloud_cfw_nat_policy`）。模块封装了策略的常见字段与校验，便于统一管理访问控制策略（入站/出站）。

## 目录结构

模块目录下常见文件与用途：

- `main.tf` — 模块主体，声明 `tencentcloud_cfw_nat_policy` 资源。
- `variables.tf` — 模块输入变量定义与说明（类型、默认值、校验）。
- `outputs.tf` — 模块导出输出（例如 `id`、`uuid` 等）。
- `versions.tf` — provider 与 Terraform 版本约束（如存在）。
- `examples/` — 示例变量文件（`.tfvars`），演示常见使用场景。
- `README.md` — 中文文档（本文件）。
- `README_EN.md` — 英文文档。

请在修改变量或输出时同步更新相应文件与 README，以保持一致性。

## 简介

该资源用于定义 NAT 层的访问控制策略（规则），支持入站（direction=1）与出站（direction=0）两种方向。

关键变量：

- `direction` (number) — 规则方向：1（入站），0（出站）。
- `port` (string) — 端口（例如 `80`、`443`、`-1` 表示全部端口）。
- `protocol` (string) — 协议，例如 `TCP`、`UDP`、`ANY` 等（出站支持更多协议，例如 `HTTP`、`HTTPS` 等）。
- `rule_action` (string) — 规则动作：`accept`（放行）、`drop`（丢弃）、`log`（观察）。
- `source_content` / `source_type` — 来源内容与类型（例如 `net:192.0.2.0/24`，类型 `net`）。
- `target_content` / `target_type` — 目的内容与类型（例如 `net:10.0.0.0/16`）。

可选字段包括 `description`、`enable`（`"true"` 或 `"false"`）、`param_template_id`（参数模板ID）及 `scope`（规则生效范围，如 `ALL` 或地域/实例维度）。

模块会创建 `tencentcloud_cfw_nat_policy` 资源并导出 `id`、`internal_uuid`、`uuid`。

## 变量

完整变量说明见 `variables.tf`；下面给出使用要点：

- `direction` 必须为 0 或 1。
- `port` 支持数字端口或 `-1`（全部端口）。
- `rule_action` 只能是 `accept`、`drop` 或 `log`。
- `enable` 为字符串类型，取值为 `"true"` 或 `"false"`（默认 `"true"`）。

示例模块引用：

```hcl
module "nat_policy_allow_http" {
  source = "../../modules/tencentcloud-cfw-nat-policy"
  direction = 1
  port = "80"
  protocol = "TCP"
  rule_action = "accept"
  source_content = "net:192.0.2.0/24"
  source_type = "net"
  target_content = "net:10.0.0.0/16"
  target_type = "net"
}
```

## 输出

- `id` — 资源 ID。
- `internal_uuid` — 内部 ID。
- `uuid` — 规则对应的全局唯一 ID（创建时无需填写，创建后可用于更新/删除）。

## 常见示例（`examples/`）

`examples/` 提供若干常见场景的 `.tfvars`：

1. `inbound_allow_http.tfvars` — 入站放行 HTTP(80) 来自网段到目标网段。
2. `inbound_drop_ip.tfvars` — 入站拒绝来自单一源 IP 的访问（例如拦截恶意 IP）。
3. `outbound_allow_all.tfvars` — 出站放通所有端口/协议（风险示例，谨慎使用）。
4. `scoped_param_template.tfvars` — 带有 `param_template_id` 与指定 `scope` 的规则示例。

使用示例：

```bash
terraform init
terraform plan -var-file=modules/tencentcloud-cfw-nat-policy/examples/inbound_allow_http.tfvars
terraform apply -var-file=modules/tencentcloud-cfw-nat-policy/examples/inbound_allow_http.tfvars
```

## 注意事项

- `source_type` 与 `target_type` 的可选值随入/出站方向而不同，请参阅 `variables.tf` 的描述。
- `enable` 使用字符串 `"true"` / `"false"`，不是布尔值，确保在调用中传入字符串类型。
- `scope` 可用于将规则限定到地域或实例维度，例如 `ap-guangzhou` 或 `cfwnat-xxx`。

如需我把 `examples/` 增加完整 caller（包含 `main.tf`）或把 README 翻译成其它语言，请告知。
