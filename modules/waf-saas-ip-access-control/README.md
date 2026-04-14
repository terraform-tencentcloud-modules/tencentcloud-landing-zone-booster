# tencentcloud-waf-saas-ip-access-control 模块

这个 Terraform 模块用于在腾讯云上创建 WAF SaaS IP 访问控制规则（tencentcloud_waf_saas_ip_access_control）。

## 说明

该模块封装了 `tencentcloud_waf_saas_ip_access_control` 资源的常用配置项，便于在不同环境中复用。主要用于为 WAF SaaS 域名配置 IP 黑白名单规则，实现对特定 IP 地址的访问控制，支持定时配置功能。

## 目录结构

下面列出模块目录中常见文件及其用途，便于快速定位与二次开发：

- `main.tf` — 模块主体，声明 `tencentcloud_waf_saas_ip_access_control` 资源及其配置。
- `variables.tf` — 模块输入变量定义与说明（类型、默认值、是否敏感等）。
- `outputs.tf` — 模块输出（导出资源 ID 和规则 ID）。
- `versions.tf` — provider 与 Terraform 版本约束，用于保证兼容性。
- `examples/` — 示例调用与变量文件，演示常见使用场景。
- `README.md` — 中文文档（本文件），包含使用说明与示例。
- `README_EN.md` — 英文文档，包含与中文对应的说明与示例。

在对模块进行改动（例如新增变量、变更输出）时，请同时更新相应的 `variables.tf` / `outputs.tf` 与文档，以保持一致性。

## 输入（Variables）

以下变量基于模块的 `variables.tf`。标注说明：Required 表示必填；可选变量给出默认值。

### 必填参数
- `instance_id` (string) — WAF 实例 ID。
- `domain` (string) — 应用规则的域名。
- `ip_list` (list(string)) — 要控制的 IP 或 CIDR 列表。
- `action_type` (number) — 访问控制类型：42: 黑名单；40: 白名单。

### 可选参数（含默认值）
- `description` (string, default null) — 规则描述。
- `job_date_time` (list(object), default []) — 定时配置详情。
  - `cron` (list(object)) — 定时执行时间参数
    - `days` (set(number)) — 每月执行的天数
    - `end_time` (string) — 结束时间
    - `start_time` (string) — 开始时间
    - `w_days` (set(number)) — 每周执行的天数
  - `time_t_zone` (string) — 时区
  - `timed` (list(object)) — 定时执行时间参数
    - `end_date_time` (number) — 结束时间戳（秒）
    - `start_date_time` (number) — 开始时间戳（秒）
- `job_type` (string, default null) — 定时配置类型。
- `note` (string, default null) — 备注。

## 输出（Outputs）

该模块导出以下输出值：

- `id` — 资源 ID
- `rule_id` — IP 访问控制规则 ID

## 基本用法示例

下面给出若干常见场景的示例配置，供参考：

### 1) 基本 IP 黑名单配置

```hcl
module "waf_ip_access_control_blacklist" {
  source      = "../../modules/tencentcloud-waf-saas-ip-access-control"
  instance_id = "waf-instance-xxxx"
  domain      = "example.com"
  ip_list     = ["192.168.1.100", "10.0.0.0/24"]
  action_type = 42  # 黑名单
  description = "阻止恶意 IP 访问"
}
```

适用于阻止特定 IP 或 IP 段访问网站的场景。

### 2) IP 白名单配置

```hcl
module "waf_ip_access_control_whitelist" {
  source      = "../../modules/tencentcloud-waf-saas-ip-access-control"
  instance_id = "waf-instance-xxxx"
  domain      = "api.example.com"
  ip_list     = ["203.0.113.10", "203.0.113.20"]
  action_type = 40  # 白名单
  description = "仅允许内部 API 调用 IP 访问"
}
```

适用于仅允许特定 IP 访问敏感接口的场景。

### 3) 定时黑名单配置

```hcl
module "waf_ip_access_control_scheduled" {
  source      = "../../modules/tencentcloud-waf-saas-ip-access-control"
  instance_id = "waf-instance-xxxx"
  domain      = "example.com"
  ip_list     = ["198.51.100.50", "198.51.100.51"]
  action_type = 42  # 黑名单
  description = "工作时间封禁异常访问 IP"
  job_type    = "cron"
  
  job_date_time = [{
    cron = [{
      days      = [1, 15, 30]  # 每月1号、15号、30号执行
      end_time  = "18:00:00"
      start_time = "09:00:00"
      w_days    = [1, 2, 3, 4, 5]  # 周一到周五
    }]
    time_t_zone = "Asia/Shanghai"
  }]
}
```

适用于需要在特定时间段内封禁 IP 的场景。

### 4) 多 IP 段控制

```hcl
module "waf_ip_access_control_multiple" {
  source      = "../../modules/tencentcloud-waf-saas-ip-access-control"
  instance_id = "waf-instance-xxxx"
  domain      = "example.com"
  ip_list     = ["192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
  action_type = 40  # 白名单
  description = "允许内部网络访问"
}
```

适用于控制整个 IP 段的访问权限。

## 定时配置详解

### cron 定时配置
- `days`: 指定每月执行的天数（1-31）
- `w_days`: 指定每周执行的天数（1-7，1=周日，7=周六）
- `start_time`: 规则生效的开始时间（HH:MM:SS格式）
- `end_time`: 规则生效的结束时间（HH:MM:SS格式）

### timed 定时配置
- `start_date_time`: 规则生效的开始时间戳（秒）
- `end_date_time`: 规则生效的结束时间戳（秒）

## 常见场景与建议

- **安全防护**：使用 `action_type = 42`（黑名单）阻止已知恶意 IP 访问网站。
- **API 保护**：使用 `action_type = 40`（白名单）限制 API 接口仅能被特定 IP 访问。
- **工作时间控制**：结合定时配置，在工作时间段内启用特定的访问控制规则。
- **IP 段管理**：支持 CIDR 表示法，便于管理整个 IP 段的访问权限。
- **临时封禁**：通过定时配置实现临时封禁功能。

## 注意事项

- 确保 `instance_id` 对应的 WAF 实例有权限管理指定域名的 IP 访问控制规则。
- `ip_list` 支持单个 IP 地址（如 `192.168.1.1`）和 CIDR 表示法（如 `192.168.1.0/24`）。
- 同一个域名可以配置多个 IP 访问控制规则，规则按创建顺序生效。
- 定时配置需要确保时间参数的准确性，避免规则生效时间错误。
- 使用定时配置时，建议先在测试环境验证配置效果。