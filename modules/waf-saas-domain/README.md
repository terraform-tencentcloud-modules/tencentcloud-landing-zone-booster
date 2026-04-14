# tencentcloud-waf-saas-domain 模块

这个 Terraform 模块用于在腾讯云上创建 WAF SaaS 域名（tencentcloud_waf_saas_domain）。

## 说明

该模块封装了 `tencentcloud_waf_saas_domain` 资源的常用配置项，便于在不同环境中复用。主要用于将域名接入 WAF 实例并配置监听端口、上游类型、证书和相关策略。

## 目录结构

下面列出模块目录中常见文件及其用途，便于快速定位与二次开发：

- `main.tf` — 模块主体，声明 `tencentcloud_waf_saas_domain` 资源及其配置。
- `variables.tf` — 模块输入变量定义与说明（类型、默认值、是否敏感等）。
- `outputs.tf` — 模块输出（如果存在，导出域名 ID、证书 ID 等）；当前模块包含 `outputs.tf`（可根据需要添加/调整导出项）。
- `versions.tf` — provider 与 Terraform 版本约束，用于保证兼容性。
- `examples/` — 示例调用与变量文件（若存在），演示常见使用场景。
- `README.md` — 中文文档（本文件），包含使用说明与示例。
- `README_EN.md` — 英文文档，包含与中文对应的说明与示例。

在对模块进行改动（例如新增变量、变更输出）时，请同时更新相应的 `variables.tf` / `outputs.tf` 与文档，以保持一致性。

## 输入（Variables）

以下变量基于模块的 `variables.tf`。标注说明：Required 表示必填；可选变量给出默认值。

- `domain` (string) — 必填。域名。
- `instance_id` (string) — 必填。WAF 实例 ID。
- `ports` (list(object)) — 必填。端口配置列表，每项包含：
  - `port` (string) 监听端口
  - `protocol` (string) 协议（例如 `http`/`https`）
  - `upstream_port` (string) 上游端口
  - `upstream_protocol` (string) 上游协议

可选参数（含默认值）：

- `active_check` (number, default 0) — 是否启用主动健康检测（0 关，1 开）。
- `api_safe_status` (number, default 0) — API 防护开关（1 开，0 关）。
- `bot_status` (number, default 0) — Bot 管控（1 开，0 关）。
- `cert_type` (number, default 0) — 证书类型：0 无证书；1 自有证书；2 托管证书。
- `cert` (string, sensitive, default null) — 证书内容（cert_type=1 时需填）。
- `private_key` (string, sensitive, default null) — 证书私钥（cert_type=1 时需填）。
- `ssl_id` (string, default null) — 托管证书 ID（cert_type=2 时需填）。
- `cipher_template` (number, default 0) — 加密套件模板（0 默认，1 通用，2 安全，3 自定义）。
- `ciphers` (list(number), default []) — 自定义加密套件编号列表（当 template=3 等）。
- `cls_status` (number, default 0) — 是否开启访问日志（1 开，0 关）。
- `https_rewrite` (number, default 0) — 是否开启 HTTP->HTTPS 跳转（1 开，0 关）。
- `https_upstream_port` (string, default null) — HTTPS 上游端口（特殊场景下需要）。
- `ip_headers` (list(string), default []) — 当 is_cdn=3 时自定义客户端 IP Header 列表。
- `is_cdn` (number, default 0) — 是否有代理在 WAF 之前（0 无，1 使用 X-Forwarded-For 首项，2 使用 remote_addr，3 使用自定义 Header）。
- `is_http2` (number, default 0) — 是否启用 HTTP/2（需要 HTTPS，1 开，0 关）。
- `is_keep_alive` (string, default "0") — 是否开启 keep-alive（"0" 关，"1" 开）。
- `is_websocket` (number, default 0) — 是否启用 WebSocket（1 开，0 关）。
- `load_balance` (string, default "0") — 负载均衡策略（"0" 轮询，"1" IP hash，"2" 加权轮询）。
- `proxy_read_timeout` (number, default 300) — 代理读取超时时间（秒）。
- `proxy_send_timeout` (number, default 300) — 代理发送超时时间（秒）。
- `sni_host` (string, default null) — 自定义 SNI 主机（当 sni_type=3）。
- `sni_type` (number, default 0) — 上游 SNI 类型（0 禁用，1 使用原始请求 host，2 使用上游 host，3 自定义 host）。
- `src_list` (list(string), default []) — 上游 IP 列表（上游类型 upstream_type=0 时需要）。
- `upstream_domain` (string, default null) — 上游域名（上游类型 upstream_type=1 时需要）。
- `upstream_scheme` (string, default "http") — 上游协议（http/https）。
- `upstream_type` (number, default 0) — 上游类型（0 IP，1 域名）。
- `weights` (list(number), default []) — 上游权重列表（对应 `src_list`/上游列表）。
- `xff_reset` (number, default 0) — 是否重写 X-Forwarded-For（0 关，1 开）。
- `status` (number, default 1) — WAF 开关状态（1 开启，0 关闭）。
- `tls_version` (number, default 1.2) — TLS 协议版本。

> 注意：`cert` 与 `private_key` 在 `variables.tf` 中被标为 sensitive，建议将它们通过安全方式（例如 Terraform Cloud/Enterprise 的敏感变量、或使用 Vault）传入。

## 输出（Outputs）

该模块目录下未发现 `outputs.tf` 文件，因此当前模块不导出任何显式输出（如果需要可以添加，如域名 ID、证书 ID 等）。

## 基本用法示例

下面给出若干常见场景的示例配置，供参考：

### 1) 最小化（HTTP 域名接入）

```hcl
module "waf_domain_basic" {
  source      = "../../modules/tencentcloud-waf-saas-domain"
  domain      = "example.com"
  instance_id = "waf-instance-xxxx"
  ports = [
    {
      port              = "80"
      protocol          = "http"
      upstream_port     = "80"
      upstream_protocol = "http"
    }
  ]
}
```

适用于仅通过 HTTP 暴露并且上游为 IP 列表或单一服务器的场景（后端用 `src_list` 或 `upstream_domain` 配置）。

### 2) 使用托管证书（HTTPS）

```hcl
module "waf_domain_https" {
  source      = "../../modules/tencentcloud-waf-saas-domain"
  domain      = "secure.example.com"
  instance_id = "waf-instance-xxxx"
  ports = [
    {
      port              = "443"
      protocol          = "https"
      upstream_port     = "443"
      upstream_protocol = "https"
    }
  ]
  cert_type = 2
  ssl_id    = "managed-cert-xxxx"
  is_http2  = 1
  https_rewrite = 1
}
```

当使用腾讯云托管证书时，将 `cert_type` 设为 `2` 并传入 `ssl_id`。可同时启用 HTTP/2 与 HTTP->HTTPS 重定向。

### 3) 自有证书 + 自定义 SNI + 上游为域名

```hcl
module "waf_domain_custom_cert" {
  source      = "../../modules/tencentcloud-waf-saas-domain"
  domain      = "api.example.com"
  instance_id = "waf-instance-xxxx"
  ports = [
    {
      port              = "443"
      protocol          = "https"
      upstream_port     = "8443"
      upstream_protocol = "https"
    }
  ]
  cert_type   = 1
  cert        = var.api_cert_pem      # sensitive
  private_key = var.api_cert_key_pem  # sensitive
  sni_type    = 3
  sni_host    = "upstream.internal.example.com"
  upstream_type = 1
  upstream_domain = "upstream.internal.example.com"
}
```

当证书为自有证书时，请通过安全方式提供 `cert` 与 `private_key`。若上游需要自定义 SNI，可设置 `sni_type=3` 并传入 `sni_host`。

### 4) 多后端（IP 列表）与加权负载

```hcl
module "waf_domain_multi_backend" {
  source      = "../../modules/tencentcloud-waf-saas-domain"
  domain      = "app.example.com"
  instance_id = "waf-instance-xxxx"
  ports = [
    {
      port              = "80"
      protocol          = "http"
      upstream_port     = "80"
      upstream_protocol = "http"
    }
  ]
  upstream_type = 0
  src_list = ["10.0.1.10", "10.0.1.11"]
  weights  = [70, 30]
  load_balance = "2" # 加权轮询
}
```

确保 `src_list` 与 `weights` 数量一致，分别对应每个上游的权重。

## 常见场景与建议

- 若在 CDN 之后再接入 WAF，请根据 CDN 填写 `is_cdn` 与 `ip_headers` 来确保获得真实客户端 IP：
  - CDN 且使用 X-Forwarded-For 首项：`is_cdn = 1`
  - CDN 且需要使用 remote_addr：`is_cdn = 2`
  - 使用自定义 header：`is_cdn = 3` 且填写 `ip_headers`。

- 推荐将私钥与证书字段作为敏感变量处理，并使用托管证书（`cert_type=2`）以降低私钥管理风险。

- 若启用 HTTP/2（`is_http2=1`），必须同时使用 HTTPS（监听 443）。

- `proxy_read_timeout` 与 `proxy_send_timeout` 根据后端响应时间酌情调整，避免出现超时导致的 502/504。

- 若需要日志与监控，开启 `cls_status = 1` 将访问日志发送到 CL S (Cloud Log Service)，便于排查与审计。

## 注意事项

- 模块当前没有导出 outputs，如果需要在调用方引用某些属性（例如创建成功后的域名 ID 或证书 ID），请在模块中添加 `outputs.tf` 并显式导出相应属性。

- 请根据实际的 WAF 实例与账号权限确保 `instance_id` 有权限对域名进行管理。

## 验证（本地测试提示）

1. 填写调用模块的 `terraform.tfvars` 或在 `module` 调用中传入必要变量。
2. 运行 `terraform init`。
3. 运行 `terraform plan -var-file=examples/basic.tfvars` 查看变更。
4. 运行 `terraform apply -var-file=examples/basic.tfvars` 创建资源。