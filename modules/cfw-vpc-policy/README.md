# tencentcloud_cfw_vpc_policy

模块用于通过 Terraform 在腾讯云上创建 VPC 防火墙策略（CFW VPC Policy）。

## 目录结构 / Directory structure

- `main.tf` - 资源定义
- `variables.tf` - 模块输入变量
- `outputs.tf` - 模块输出
- `examples/` - 示例 `*.tfvars` 文件，用于 `terraform plan -var-file=examples/*.tfvars`

## 简介
该模块将根据传入参数在指定防火墙实例（或默认 ALL）下创建一条 VPC 策略（访问控制规则）。常用于允许/拒绝特定源到目标的网络访问。

## Inputs / 输入

| 名称 | 类型 | 必需 | 默认 | 说明 |
|---|---:|:---:|---|---|
| `description` | string | yes | — | 规则描述 |
| `dest_content` | string | yes | — | 目标地址内容，例如 `net:192.168.0.0/24` 或 `domain:*.example.com` |
| `dest_type` | string | yes | — | 目标类型：`net` 或 `template` |
| `port` | string | yes | — | 端口，`-1` 表示所有端口，或具体端口如 `80` |
| `protocol` | string | yes | — | 协议，见 `variables.tf` 中允许值（例如 `TCP`, `UDP`, `HTTP` 等） |
| `rule_action` | string | yes | — | 处理动作：`accept` / `drop` / `log` |
| `source_content` | string | yes | — | 源地址内容，例如 `net:10.0.0.0/16` |
| `source_type` | string | yes | — | 源类型：`net` 或 `template` |
| `enable` | string | no | `true` | 是否启用规则，`true` 或 `false` |
| `fw_group_id` | string | no | `ALL` | 防火墙实例 ID，默认作用于所有防火墙 |

注意：`enable` 采用字符串 `"true"`/`"false"`（与模块定义一致）。

## Outputs / 输出

| 名称 | 说明 |
|---|---|
| `id` | 资源 ID |
| `beta_list` | Beta 信息（可能为 null） |
| `fw_group_name` | 防火墙名称 |
| `internal_uuid` | 内部使用的 uuid |
| `param_template_id` | 参数模版 ID（可能为 null） |
| `param_template_name` | 参数模版名称（可能为 null） |
| `uuid` | 规则对应的唯一 uuid |

## 示例 / Examples

示例文件都放在 `examples/` 目录下，使用方法示例：

```bash
terraform init
terraform plan -var-file=examples/basic_allow.tfvars
```

示例说明：

- `basic_allow.tfvars`：一个最小的允许规则示例（源 net -> 目标 net，允许所有端口）。
- `drop_http.tfvars`：拒绝从某个源到目标域名的 HTTP 访问，仅针对 80 端口。
- `template_block.tfvars`：使用 `template` 类型（基于模板）对目标进行封禁/放行示例。
- `disabled_rule.tfvars`：创建但不启用的规则（`enable = "false"`）。

## 注意事项 / Notes

- 请不要在仓库中提交真实的私密信息。
- `fw_group_id` 为 `ALL` 表示策略默认作用到所有可用防火墙实例；若需限定到单个实例，请传入防火墙实例 ID。
- 运行 `terraform apply` 将在腾讯云中创建真实规则，请在受控环境中运行或先使用 `plan` 验证。
