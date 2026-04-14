# tencentcloud_cfw_vpc_firewall_switch module

This Terraform module manages the CFW (Cloud Firewall) sync assets on Tencent Cloud (`tencentcloud_cfw_sync_asset`). It is a lightweight wrapper around the provider resource.

## Overview

It creates/updates the `tencentcloud_cfw_sync_asset` resource.

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_vpc_firewall_switch` resource.
- `variables.tf` — Input variable definitions and validation.
- `outputs.tf` — Exported outputs (for example the resource `id`).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `examples/` — Example usages and `.tfvars` files demonstrating common scenarios.
- `README.md` — Chinese README for the module.
- `README_EN.md` — English README for the module (this file).

When you change the module (add variables, outputs, or examples), please update `variables.tf` / `outputs.tf` and these READMEs accordingly to keep documentation in sync.

## Variables

## Outputs

## Examples (in `examples/`)

1. Enable the firewall switch — `examples/enable.tfvars`
2. Disable the firewall switch — `examples/disable.tfvars`
3. Custom placeholder example — `examples/example_custom.tfvars`

Each example is a `.tfvars` file so you can run `terraform plan -var-file=...` or `terraform apply -var-file=...`.

## Local testing

1. Add a `main.tf` in the caller directory referencing this module.
2. Run:

```bash
terraform init
terraform plan -var-file=examples/enable.tfvars
terraform apply -var-file=examples/enable.tfvars
```

Notes:

- `switch_id` and `vpc_ins_id` are ForceNew — changing them will replace the resource.
- Ensure your Tencent Cloud credentials have permissions to manage the firewall instance.
