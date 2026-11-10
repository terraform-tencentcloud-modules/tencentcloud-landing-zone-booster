# tencentcloud-waf-log-post-ckafka-flow 模块

该 Terraform 模块用于将 WAF 日志投递到 CKafka（腾讯云消息队列）的配置，基于资源 `tencentcloud_waf_log_post_ckafka_flow`。

## 说明

模块将 CKafka 连接参数、主题、压缩与版本信息等配置为模块输入，支持可选的 SASL 验证与写入字段开关（`write_config`）。常见用途包括将 WAF 访问/攻击日志可靠地推送到 CKafka，用于日志分析、实时监控或下游处理。

## 目录结构

- `main.tf` — 资源主体，声明 `tencentcloud_waf_log_post_ckafka_flow`。
- `variables.tf` — 模块输入变量定义（必需与可选变量、校验规则及敏感标记）。
- `outputs.tf` — 模块导出的属性（`id`, `flow_id`, `status`）。
- `examples/` — 示例 `*.tfvars` 用于快速测试（请替换占位值）。
- `README.md` — 本文档（中文）。
- `README_EN.md` — 英文文档。

在变更模块接口（新增/修改变量或输出）时，请同时更新文档与示例文件以保持一致。

## 输入（Variables）

必需参数：

- `brokers` (string) — CKafka 地址列表（支持内部 IP:PORT 或外网 domain:PORT）。
- `ckafka_id` (string) — CKafka 实例 ID。
- `ckafka_region` (string) — CKafka 所在区域（用于投递定位）。
- `compression` (string) — 压缩类型，必须为 `none`、`snappy`、`gzip` 或 `lz4`（建议 `snappy`）。
- `kafka_version` (string) — Kafka 集群版本号。
- `log_type` (number) — 日志类型：1 = 访问日志，2 = 攻击日志（必须为 1 或 2）。
- `topic` (string) — 主题名称（默认 `waf_post_access_log`）。
- `vip_type` (number) — 1 = 外网 TGW，2 = 支撑环境（默认 2）。

可选参数：

- `sasl_enable` (number) — 是否启用 SASL（0 关闭，1 启用，默认 0）。
- `sasl_user` (string) — SASL 用户名（可选，sasl_enable=1 时可能需要）。
- `sasl_password` (string, sensitive) — SASL 密码（敏感，建议通过安全变量注入）。
- `write_config` (list(object), default []) — 写入字段控制列表，允许为每个写入配置设置 `enable_body` / `enable_bot` / `enable_headers`（0/1）。示例类型详见 `variables.tf`。

> 注意：`sasl_password` 被标记为 sensitive，请不要将真实密码提交到版本控制系统。可使用 Terraform Cloud、Vault 或 CI Secret 注入。

## 输出（Outputs）

- `id` — 资源的 Terraform ID。
- `flow_id` — 投递流的唯一 ID，可用于线上排查与查询。
- `status` — 状态（0 = 关闭，1 = 开启）。

## 常见示例

以下示例文件位于 `examples/`，均为 `.tfvars`，在使用前请替换示例中的占位值（例如 `ckafka_id`、`brokers` 等）。

1) 基本接入（最小化） — `examples/basic.tfvars`
- 适用于将访问日志投递到 CKafka（不启用 SASL 或特殊 write_config）。

2) 投递攻击日志 — `examples/attack_log.tfvars`
- 通过设置 `log_type = 2` 将攻击日志投递至指定主题。

3) 启用 SASL 验证 — `examples/sasl.tfvars`
- 在内网或安全要求较高的场景下启用 SASL（示例中 `sasl_password` 使用占位符且标记为敏感）。

4) 自定义写入字段 — `examples/write_config.tfvars`
- 使用 `write_config` 动态块控制是否投递请求体、Bot 信息或 headers 等字段。

## 使用示例（调用模块）

```hcl
module "waf_ckafka_flow" {
  source = "../../modules/tencentcloud-waf-log-post-ckafka-flow"

  brokers       = var.brokers
  ckafka_id     = var.ckafka_id
  ckafka_region = var.ckafka_region
  compression   = var.compression
  kafka_version = var.kafka_version
  log_type      = var.log_type
  topic         = var.topic
  vip_type      = var.vip_type

  sasl_enable   = var.sasl_enable
  sasl_user     = var.sasl_user
  sasl_password = var.sasl_password
  write_config  = var.write_config
}
```

本地快速测试（示例）：

```bash
terraform init
terraform plan -var-file=examples/basic.tfvars
terraform apply -var-file=examples/basic.tfvars
```

> 执行前请确保 `ckafka_id` 与 `brokers` 指向测试环境，生产环境会收到真实投递流量。

## 注意事项与排查建议

- `compression` 需要与目标 CKafka 集群支持的压缩方式一致，否则可能写入失败或出现数据异常。
- 若启用 SASL，确保 `sasl_user`/`sasl_password` 与 CKafka 集群配置匹配，且密码通过安全机制注入。
- 若未收到日志，请检查 `flow_id`、CKafka topic 权限与网络连通性（broker 可达性、端口、白名单）。

