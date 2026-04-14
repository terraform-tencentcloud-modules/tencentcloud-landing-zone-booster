```markdown
# tencentcloud-waf-instance-attack-log-post-config 模块

该 Terraform 模块用于配置 WAF 实例的攻击日志投递开关，基于资源 `tencentcloud_waf_instance_attack_log_post_config`。

## 说明

此模块允许开启或关闭指定 WAF 实例的“攻击日志投递”（attack log post）。典型场景：需要将攻击日志转发到下游系统或日志平台以便分析与告警时，开启该功能；测试或节省成本时可关闭。

## 目录结构

- `main.tf` — 资源定义，声明 `tencentcloud_waf_instance_attack_log_post_config`。
- `variables.tf` — 定义模块输入变量（`attack_log_post`, `instance_id`）。
- `outputs.tf` — 导出 `id`。
- `examples/` — 示例 `*.tfvars` 文件，用于快速 `plan`/`apply` 测试（本目录下包含 `enable.tfvars` 与 `disable.tfvars`）。
- `README.md` — 本文档（中文）。
- `README_EN.md` — 英文版本文档。

修改模块变量或输出时，请同步更新相应的文档与示例文件。

## 输入（Variables）

- `attack_log_post` (number) — 必填。攻击日志投递开关：0 = 关闭，1 = 开启。
  - 在 `variables.tf` 中已对值进行验证，必须为 0 或 1。
- `instance_id` (string) — 必填。目标 WAF 实例 ID（强制变更 ForceNew）。

示例变量类型与约束均以 `variables.tf` 为准，请在调用模块时传入合法值。

## 输出（Outputs）

- `id` — Terraform 资源 ID，来自 `tencentcloud_waf_instance_attack_log_post_config` 资源。

## 使用示例

下面示例展示如何在调用方使用本模块以及如何利用 `examples/*.tfvars` 快速测试。

模块调用（示例）：

```hcl
module "waf_attack_log_post" {
  source        = "../../modules/tencentcloud-waf-instance-attack-log-post-config"
  attack_log_post = var.attack_log_post
  instance_id     = var.instance_id
}

# 在调用方变量中可采用 -var-file 指定 examples 中的 tfvars，例如：
# terraform plan -var-file=examples/enable.tfvars
```

### 示例 1 — 启用攻击日志投递

使用 `examples/enable.tfvars`（包含 `attack_log_post = 1`）来开启投递。

### 示例 2 — 关闭攻击日志投递

使用 `examples/disable.tfvars`（包含 `attack_log_post = 0`）来关闭投递。

## 注意事项

- `instance_id` 为强制变更字段（ForceNew），修改此值会触发资源重建，请在更改前评估影响。
- 此操作通常不会直接触发额外计费，但可能影响日志下游系统接收策略，请在生产环境变更前做好验证与回滚计划。

## 本地验证（快速）

1. 在调用方目录创建 `main.tf` 并引用本模块或直接在模块根目录临时调用（谨慎，生产环境会生效）。
2. 使用示例文件：

```bash
terraform init
terraform plan -var-file=examples/enable.tfvars
terraform apply -var-file=examples/enable.tfvars
```

3. 若要关闭：

```bash
terraform apply -var-file=examples/disable.tfvars
```

请在执行前确认 `instance_id` 是目标测试实例且不会影响生产环境。

```
