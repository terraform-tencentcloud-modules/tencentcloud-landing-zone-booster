```markdown
# tencentcloud-waf-instance-attack-log-post-config module

This Terraform module configures the attack log post setting for a WAF instance using the `tencentcloud_waf_instance_attack_log_post_config` resource.

## Overview

The module lets you enable or disable attack log delivery for a specific WAF instance. Enable delivery when you want attack logs forwarded to downstream systems or logging platforms for analysis/alerting; disable for testing or to reduce downstream traffic.

## Directory structure

- `main.tf` — Resource declaration for `tencentcloud_waf_instance_attack_log_post_config`.
- `variables.tf` — Module inputs (`attack_log_post`, `instance_id`).
- `outputs.tf` — Module outputs (`id`).
- `examples/` — Example `*.tfvars` for quick testing (contains `enable.tfvars` and `disable.tfvars`).
- `README.md` — Chinese documentation.
- `README_EN.md` — This file.

When changing module inputs or outputs, update the docs and examples accordingly.

## Inputs (Variables)

- `attack_log_post` (number) — Required. Attack log delivery switch: 0 = disable, 1 = enable.
  - `variables.tf` validates the value must be 0 or 1.
- `instance_id` (string) — Required. Target WAF instance ID (ForceNew).

## Outputs

- `id` — Terraform resource ID of the created configuration resource.

## Usage example

Call the module from a root module and pass variables. You can leverage the provided examples for quick testing with `-var-file`.

Example module usage:

```hcl
module "waf_attack_log_post" {
  source = "../../modules/tencentcloud-waf-instance-attack-log-post-config"
  attack_log_post = var.attack_log_post
  instance_id     = var.instance_id
}

# Plan with example file:
# terraform plan -var-file=examples/enable.tfvars
```

### Example 1 — Enable attack log post

Use `examples/enable.tfvars` (sets `attack_log_post = 1`).

### Example 2 — Disable attack log post

Use `examples/disable.tfvars` (sets `attack_log_post = 0`).

## Notes

- Changing `instance_id` triggers resource recreation (ForceNew). Consider implications before modifying.
- This configuration itself should not incur additional billing, but downstream systems may receive increased log volume when enabled.

## Quick local test

```bash
terraform init
terraform plan -var-file=examples/enable.tfvars
terraform apply -var-file=examples/enable.tfvars
```

To disable:

```bash
terraform apply -var-file=examples/disable.tfvars
```

Ensure the `instance_id` in your example files points to a test instance and not a production instance.

```
