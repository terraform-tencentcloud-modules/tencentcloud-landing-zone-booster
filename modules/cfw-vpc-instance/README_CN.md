# tencentcloud_cfw_vpc_instance 模块

该 Terraform 模块用于在腾讯云上创建 VPC 防火墙（防火墙组 / VPC 实例），基于资源 `tencentcloud_cfw_vpc_instance`。

## 说明

该模块封装了 VPC 防火墙（组）创建与多个防火墙实例的部署配置，支持私网模式与 CCN（云联网）模式。模块使用嵌套对象 `vpc_fw_instances` 描述每个防火墙实例以及其在各可用区/地域的部署（`fw_deploy`）。

典型用途：跨 VPC 或跨地域部署统一防火墙组、基于 CCN 架构的集中管理防火墙、或自定义防火墙网络段。

## 目录结构

- `main.tf` — 模块主体，声明 `tencentcloud_cfw_vpc_instance` 资源并处理动态 `vpc_fw_instances` 块。
- `variables.tf` — 输入变量定义（包括 `vpc_fw_instances` 的对象结构和校验规则）。
- `outputs.tf` — 模块输出（当前导出 `id`）。
- `examples/` — 示例 `*.tfvars` 文件，展示常见部署场景。
- `README.md` — 中文文档（本文件）。
- `README_EN.md` — 英文文档。

变更模块接口时请同步更新 `variables.tf` 与文档。

## 输入（Variables）

必填参数：

- `mode` (number) — 模式：0 = 私有网络模式，1 = CCN 云联网模式。必须为 0 或 1。
- `name` (string) — 防火墙（组）名称。
- `switch_mode` (number) — 防火墙实例开关模式：1 单点互通、2 多点互通、4 自定义路由（必须为 1、2 或 4）。
- `vpc_fw_instances` (list(object)) — 防火墙实例列表，每项包含：
  - `name` (string) — 实例名称。
  - `vpc_ids` (optional set(string)) — 关联的 VPC 列表（可选）。
  - `fw_deploy` (list(object)) — 部署配置列表，每项包含：
    - `deploy_region` (string) — 部署地域。
    - `width` (number) — 带宽/宽度配置。
    - `zone_set` (set(string)) — 可用区集合。
    - `cross_a_zone` (optional number) — 是否启用跨可用区（可选）。

可选参数：

- `ccn_id` (string, default null) — 云联网 ID（仅在 CCN 模式下使用）。
- `fw_vpc_cidr` (string, default "auto") — 防火墙 VPC CIDR，支持 `auto`（自动选择）或指定网段（例如 `10.10.10.0/24`）。

> 注意：`vpc_fw_instances` 是一个复杂对象，请参考示例（`examples/`）了解如何构造该参数。

## 输出（Outputs）

- `id` — Terraform 资源 ID。

## 示例（使用场景）

示例文件位于 `examples/`，均为 `.tfvars`，使用前请替换示例占位值并根据实际需求调整：

1) 私有网络模式（最小化） — `examples/basic_private.tfvars`
- mode=0，单实例部署，使用默认 fw_vpc_cidr（自动分配）。

2) CCN 云联网模式 — `examples/ccn_mode.tfvars`
- mode=1，提供 `ccn_id` 并在多个 VPC 上部署实例。

3) 多实例与多区域部署 — `examples/multi_instances.tfvars`
- 演示在同一防火墙组下部署多个实例，每个实例有多个 `fw_deploy` 条目。

4) 自定义防火墙网段 — `examples/custom_cidr.tfvars`
- 指定 `fw_vpc_cidr`（例如 `10.10.10.0/24`）以固定防火墙网络段。

## 模块调用示例

在调用方引用模块并传入变量：

```hcl
module "cfw_vpc" {
  source = "../../modules/tencentcloud-cfw-vpc-instance"

  mode        = var.mode
  name        = var.name
  switch_mode = var.switch_mode
  vpc_fw_instances = var.vpc_fw_instances

  # 可选
  # ccn_id = var.ccn_id
  # fw_vpc_cidr = var.fw_vpc_cidr
}
```

使用示例文件执行：

```bash
terraform init
terraform plan -var-file=examples/basic_private.tfvars
terraform apply -var-file=examples/basic_private.tfvars
```

> 执行前请确认所有 `vpc_ids`、`ccn_id` 等参数均为测试环境或在可控范围内操作。

## 注意事项 & 排查

- `mode=1`（CCN）场景需要提供 `ccn_id`，且网络与权限需提前准备。
- 修改 `vpc_fw_instances` 中的部署配置会触发资源变更，请评估影响并在维护窗口执行。
- `fw_vpc_cidr` 若指定不当，可能与现有网络冲突，请在指定前进行冲突检查。

