````markdown
# tencentcloud-waf-saas-instance 模块

此 Terraform 模块用于在腾讯云上创建 WAF SaaS 实例（`tencentcloud_waf_saas_instance`）。模块将常用计费/能力参数抽象为输入变量，便于在不同环境下复用与自动化部署。

## 说明

该模块负责创建一个 WAF SaaS 实例，并可选择开启 API 安全、Bot 管理或弹性计费等能力。常见用途包括：购买新的 WAF SaaS 实例、为已存在环境快速创建隔离实例、以及在 IaC 流程中统一管理计费与到期策略。

## 目录结构

模块目录中常见文件及其用途：

- `main.tf` — 模块主体，声明 `tencentcloud_waf_saas_instance` 资源并绑定输入变量。
- `variables.tf` — 模块输入变量定义（类型、默认值与说明）。
- `outputs.tf` — 模块输出（导出创建后的 `id`、`instance_id`、`status` 等）。
- `versions.tf` — Terraform 与 provider 版本约束（若存在）。
- `README.md` — 中文使用说明（本文件）。
- `README_EN.md` — 英文使用说明（对应英文版）。
- `examples/` — 若存在，放置示例调用与 `*.tfvars` 文件。

修改模块接口（新增变量或输出）时，请同时更新 `variables.tf` / `outputs.tf` 与本文件以保持一致。

## 输入（Variables）

下面的变量来源于模块的 `variables.tf`：

- `instance_name` (string) — WAF 实例名称（必填）。
- `goods_category` (string) — 计费类型（必填）。支持值示例：`premium_saas`, `enterprise_saas`, `ultimate_saas`。
- `api_security` (number, default 0) — 是否购买 API 安全：1 开启，0 关闭（可选）。
- `auto_renew_flag` (number, default 0) — 自动续费标识：1 开启，0 关闭（可选）。
- `bot_management` (number, default 0) — 是否购买 Bot 管理：1 开启，0 关闭（可选）。
- `elastic_mode` (number, default 0) — 是否启用弹性计费：1 启用，0 禁用（可选）。
- `qps_limit` (number, default null) — QPS 限额（仅当 `elastic_mode = 1` 时有效，最小值示例 10000）。
- `real_region` (string, default "sg") — 实例对应的真实区域/节点标识（可选，模块中给出常见取值，参见 `variables.tf` 注释）。
- `time_span` (number, default 1) — 购买时长，数值。
- `time_unit` (string, default "m") — 时长单位：`d`/`m`/`y`（日/月/年）。

示例：若需要弹性计费并设定 QPS 限额，请将 `elastic_mode = 1` 且设置 `qps_limit`（例如 20000）。

## 输出（Outputs）

模块在 `outputs.tf` 中导出的属性如下：

- `id` — Terraform 资源 ID。
- `instance_id` — WAF 实例 ID（用于后续为域名或策略绑定实例）。
- `edition` — 实例版本/类型（例如 `clb` 或 `saas`）。
- `status` — 实例状态（字符串或数字，取决于 provider 返回值）。
- `begin_time` — 实例生效时间。
- `valid_time` — 实例到期/有效时间。

## 常见使用示例

下面给出若干典型调用场景，示例均为模块调用片段（简化）。根据实际使用请在调用方填写 `provider`、认证与 `terraform` 基本配置。

### 1) 基本购买（最小化）

适用于只需创建基础 SaaS 实例的场景。

```hcl
module "waf_instance_basic" {
  source        = "../../modules/tencentcloud-waf-saas-instance"
  instance_name = "waf-basic-01"
  goods_category = "premium_saas"
}
```

### 2) 包含 API 安全与 Bot 管控

开启额外能力以保护 API 与应对 Bot 流量。

```hcl
module "waf_instance_protect" {
  source         = "../../modules/tencentcloud-waf-saas-instance"
  instance_name  = "waf-protect-01"
  goods_category = "enterprise_saas"
  api_security   = 1
  bot_management = 1
}
```

### 3) 弹性计费（带 QPS 限额）

适用于按需伸缩或需要设置 QPS 上限的场景。注意：`qps_limit` 仅在 `elastic_mode = 1` 时生效，最小建议值 10000（以 provider 要求为准）。

```hcl
module "waf_instance_elastic" {
  source        = "../../modules/tencentcloud-waf-saas-instance"
  instance_name = "waf-elastic-01"
  goods_category = "ultimate_saas"
  elastic_mode  = 1
  qps_limit     = 20000
  real_region   = "gz"
}
```

### 4) 自动续费按月购买

```hcl
module "waf_instance_renew" {
  source         = "../../modules/tencentcloud-waf-saas-instance"
  instance_name  = "waf-auto-01"
  goods_category = "premium_saas"
  auto_renew_flag = 1
  time_span      = 1
  time_unit      = "m"
}
```

## 注意事项

- `qps_limit`：仅在弹性计费开启时生效，且有最小值限制，具体以腾讯云接口/文档为准。不要在 `elastic_mode = 0` 时设置该值。
- `real_region`：变量注释列出了常见取值，请根据实际需求选择节点位置，影响线路/节点分配。
- 生产环境中请配合合适的权限与账单配置创建实例，避免重复购买导致浪费。

## 本地验证（快速）

1. 在引用本模块的目录中填写变量或使用 `-var-file` 指定 `*.tfvars`。
2. 运行 `terraform init`。
3. 运行 `terraform plan` 查看将要创建的资源。
4. 运行 `terraform apply` 创建实例（注意操作会触发真实计费）。

````
