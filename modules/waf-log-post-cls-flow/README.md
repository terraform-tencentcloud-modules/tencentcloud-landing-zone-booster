# tencentcloud-waf-log-post-cls-flow 模块

该 Terraform 模块用于将 WAF 日志（访问或攻击日志）投递到腾讯云日志服务 CLS（Cloud Log Service），基于资源 `tencentcloud_waf_log_post_cls_flow`。

## 说明

模块提供了最小化的配置（大多数参数均有默认值），你可以快速启用将 WAF 日志投递到 CLS 的能力。常见场景包括统一日志管理、审计、离线分析或告警触发。

## 目录结构

- `main.tf` — 模块主体，声明 `tencentcloud_waf_log_post_cls_flow` 资源。
- `variables.tf` — 模块输入变量（含默认值与校验）。
- `outputs.tf` — 模块输出（`id`、`flow_id`、`log_topic_id`、`logset_id`、`status`）。
- `examples/` — 示例 `*.tfvars`，用于快速测试（请替换占位值和按需调整）。
- `README.md` — 本文档（中文）。
- `README_EN.md` — 英文文档。

## 输入（Variables）

本模块的参数在 `variables.tf` 中定义且均为可选，提供的默认值适用于多数场景：

- `cls_region` (string, default `ap-shanghai`) — CLS 所在区域，用于投递定位。
- `log_topic_name` (string, default `waf_post_logtopic`) — CLS 日志主题名（log topic）。
- `log_type` (number, default `1`) — 日志类型：1 = 访问日志，2 = 攻击日志。
- `logset_name` (string, default `waf_post_logset`) — CLS 日志集名称（logset）。

如果需要更细粒度控制（如自定义主题、不同区域），请在调用模块时覆盖这些参数。

## 输出（Outputs）

- `id` — Terraform 资源 ID。
- `flow_id` — 投递流的唯一 ID，可用于控制台查询和排查。
- `log_topic_id` — CLS 日志主题 ID。
- `logset_id` — CLS 日志集 ID。
- `status` — 投递状态：0 = 关闭，1 = 启用。

## 常见示例

示例文件位于 `examples/`，均为 `.tfvars` 文件，使用前请根据实际环境修改占位值（如 region、topic 名称等）。

### 1) 基本（默认配置） — `examples/basic.tfvars`
使用模块默认值将访问日志投递到默认的日志主题与日志集。

### 2) 投递攻击日志 — `examples/attack_log.tfvars`
设置 `log_type = 2` 将攻击日志投递到 CLS。

### 3) 自定义主题与日志集名 — `examples/custom_names.tfvars`
自定义 `log_topic_name` 与 `logset_name`，适用于已有 CLS 命名规范的场景。

### 4) 指定区域 — `examples/region.tfvars`
将 CLS 投递目标改为其他可用区域，例如 `ap-beijing` 或 `ap-guangzhou`。

## 使用示例（模块调用）

```hcl
module "waf_cls_flow" {
  source = "../../modules/tencentcloud-waf-log-post-cls-flow"

  # 可选覆盖示例
  # cls_region    = "ap-guangzhou"
  # log_topic_name = "my_waf_topic"
  # log_type      = 2
  # logset_name   = "my_waf_logset"
}
```

通过示例文件运行：

```bash
terraform init
terraform plan -var-file=examples/basic.tfvars
terraform apply -var-file=examples/basic.tfvars
```

> 注意：apply 操作会在真实 CLS 中创建投递配置，请在测试环境中验证并替换占位值。

## 排查建议

- 若未收到日志，请检查 `flow_id`、CLS 日志主题与日志集权限、网络连通性（CLS API 可达）以及 WAF 控制台中的投递状态。
- 如果使用自定义 `log_topic_name`/`logset_name`，确保目标已创建且调用方账号有写入权限。

