```markdown
# tencentcloud-waf-saas-instance module

This Terraform module provisions a WAF SaaS instance on Tencent Cloud using the `tencentcloud_waf_saas_instance` resource. It exposes common billing and capability options as inputs for easy reuse and automation.

## Overview

The module creates a WAF SaaS instance and can optionally enable API Security, Bot Management, or elastic billing. Typical use cases include provisioning new WAF instances, creating isolated instances for environments, and standardizing billing/expiration via IaC.

## Directory structure

# tencentcloud-waf-saas-instance module

This Terraform module provisions a WAF SaaS instance on Tencent Cloud using the `tencentcloud_waf_saas_instance` resource. It exposes common billing and capability options as inputs for easy reuse and automation.

## Overview

The module creates a WAF SaaS instance and can optionally enable API Security, Bot Management, or elastic billing. Typical use cases include provisioning new WAF instances, creating isolated instances for environments, and standardizing billing/expiration via IaC.

## Directory structure

Common files in the module and their purpose:

- `main.tf` — Module entry; declares `tencentcloud_waf_saas_instance` resource and binds input variables.
- `variables.tf` — Input variable definitions (types, defaults, and descriptions).
- `outputs.tf` — Module outputs (exports such as `id`, `instance_id`, `status`, etc.).
- `versions.tf` — Terraform/provider version constraints (if present).
- `README.md` — Chinese documentation for the module.
- `README_EN.md` — English documentation (this file).
- `examples/` — Example usage and `*.tfvars` files (if present).

When changing module inputs/outputs, update `variables.tf`/`outputs.tf` and documentation accordingly.

## Inputs (Variables)

Variables are defined in `variables.tf`:

- `instance_name` (string) — WAF instance name (required).
- `goods_category` (string) — Billing category (required). Example supported values: `premium_saas`, `enterprise_saas`, `ultimate_saas`.
- `api_security` (number, default 0) — Purchase API Security: 1 = yes, 0 = no.
- `auto_renew_flag` (number, default 0) — Auto renew: 1 = enable, 0 = disable.
- `bot_management` (number, default 0) — Purchase Bot Management: 1 = yes, 0 = no.
- `elastic_mode` (number, default 0) — Enable elastic billing: 1 = enable, 0 = disable.
- `qps_limit` (number, default null) — QPS limit (effective only when `elastic_mode = 1`, minimum recommended 10000).
- `real_region` (string, default "sg") — Real region/node identifier (see `variables.tf` comment for supported values).
- `time_span` (number, default 1) — Purchase duration value.
- `time_unit` (string, default "m") — Time unit: `d`/`m`/`y` (day/month/year).

Note: set `elastic_mode = 1` to enable `qps_limit`.

## Outputs

The module exports the following outputs (see `outputs.tf`):

- `id` — Terraform resource ID.
- `instance_id` — WAF instance ID for subsequent domain/policy bindings.
- `edition` — Instance edition/type (e.g., `clb` or `saas`).
- `status` — Instance status.
- `begin_time` — Instance start time.
- `valid_time` — Instance validity/expiration time.

## Examples

Below are common invocation examples. These snippets assume you configured provider/authentication in the caller.

### 1) Basic purchase

```hcl
module "waf_instance_basic" {
  source         = "../../modules/tencentcloud-waf-saas-instance"
  instance_name  = "waf-basic-01"
  goods_category = "premium_saas"
}
```

### 2) With API Security and Bot Management

```hcl
module "waf_instance_protect" {
  source         = "../../modules/tencentcloud-waf-saas-instance"
  instance_name  = "waf-protect-01"
  goods_category = "enterprise_saas"
  api_security   = 1
  bot_management = 1
}
```

### 3) Elastic billing with QPS limit

Only valid when `elastic_mode = 1`.

```hcl
module "waf_instance_elastic" {
  source         = "../../modules/tencentcloud-waf-saas-instance"
  instance_name  = "waf-elastic-01"
  goods_category = "ultimate_saas"
  elastic_mode   = 1
  qps_limit      = 20000
  real_region    = "gz"
}
```

### 4) Auto-renew monthly

```hcl
module "waf_instance_renew" {
  source          = "../../modules/tencentcloud-waf-saas-instance"
  instance_name   = "waf-auto-01"
  goods_category  = "premium_saas"
  auto_renew_flag = 1
  time_span       = 1
  time_unit       = "m"
}
```

## Notes

- `qps_limit`: effective only when `elastic_mode = 1`. Observe provider limits and minimums.
- `real_region`: choose node location per `variables.tf` comments — it impacts node allocation and routing.
- Creating instances triggers actual billing; review account/billing settings before apply.

## Quick local test

1. Provide variables or a `-var-file` referencing values.
2. `terraform init`.
3. `terraform plan`.
4. `terraform apply` (this will create real billed resources).
