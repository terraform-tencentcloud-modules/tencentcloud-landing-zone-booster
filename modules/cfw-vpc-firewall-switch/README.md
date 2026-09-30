# tencentcloud_cfw_vpc_firewall_switch module

This Terraform module manages the CFW (Cloud Firewall) VPC firewall switch resource on Tencent Cloud (`tencentcloud_cfw_vpc_firewall_switch`). It is a lightweight wrapper around the provider resource and exposes the minimal required inputs to turn a firewall switch on or off for a specific firewall instance.

## Overview

The module exposes three required input variables:

- `enable`: Switch state (number, 0 = off, 1 = on).
- `switch_id`: Firewall switch ID (string).
- `vpc_ins_id`: Firewall instance ID (string).

It creates/updates the `tencentcloud_cfw_vpc_firewall_switch` resource and exports the resource `id`.

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

From `variables.tf` (all required):

- `enable` (number) — Required. Switch state: 0 off, 1 on. The module validates the value must be 0 or 1.
- `switch_id` (string) — Required. The firewall switch ID. (ForceNew on change.)
- `vpc_ins_id` (string) — Required. The firewall instance ID. (ForceNew on change.)

Example usage:

```hcl
module "cfw_switch" {
  source     = "../../modules/tencentcloud-cfw-vpc-firewall-switch"
  enable     = 1
  switch_id  = "cfw-switch-xxxx"
  vpc_ins_id = "vpc-ins-xxxx"
}
```

## Outputs

- `id` — The resource ID from `tencentcloud_cfw_vpc_firewall_switch`.

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
