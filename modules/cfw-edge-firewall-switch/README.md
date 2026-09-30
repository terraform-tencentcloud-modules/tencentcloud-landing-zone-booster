# tencentcloud_cfw_edge_firewall_switch module

This Terraform module manages the CFW (Cloud Firewall) edge firewall switch resource on Tencent Cloud (`tencentcloud_cfw_edge_firewall_switch`). It is a lightweight wrapper around the provider resource and exposes the minimal required inputs to turn an edge firewall switch on or off for a specific public IP, with support for bypass (0) or serial (1) switch mode.

## Overview

The module exposes four input variables:

- `public_ip`: The public IP associated with the edge firewall switch (string, required).
- `subnet_id`: Subnet ID used to create the private connection when the first EIP switch in the VPC is turned on (string, optional; required when `switch_mode` is `1` and `enable` is `1`).
- `switch_mode`: Switch mode (number, optional, default `1`): `0` = bypass, `1` = serial.
- `enable`: Switch state (number, optional, default `1`): `0` = off, `1` = on.

It creates/updates the `tencentcloud_cfw_edge_firewall_switch` resource. This module does not export any outputs (`outputs.tf` is intentionally empty).

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_edge_firewall_switch` resource.
- `variables.tf` — Input variable definitions and default values.
- `outputs.tf` — Exported outputs (empty for this module; no outputs are exposed).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `examples/` — Example usages and `.tfvars` files demonstrating common scenarios.
- `README.md` — Chinese README for the module.
- `README_EN.md` — English README for the module (this file).

When you change the module (add variables, outputs, or examples), please update `variables.tf` / `outputs.tf` and these READMEs accordingly to keep documentation in sync.

## Variables

From `variables.tf`:

- `public_ip` (string) — Required. The public IP of the edge firewall switch.
- `subnet_id` (string) — Optional, default `null`. The subnet ID for the private connection. Required only when `switch_mode` is `1` and `enable` is `1`.
- `switch_mode` (number) — Optional, default `1`. Switch mode: `0` = bypass, `1` = serial.
- `enable` (number) — Optional, default `1`. Switch state: `0` = off, `1` = on.

Example usage:

```hcl
module "cfw_edge_switch" {
  source      = "../../modules/tencentcloud-cfw-edge-firewall-switch"
  public_ip   = "10.110.20.10"
  subnet_id   = "subnet-id"
  switch_mode = 1
  enable      = 1
}
```

## Outputs

This module does not export any outputs. `outputs.tf` is intentionally empty.

## Examples (in `examples/`)

1. Serial mode, switch enabled — `examples/switch_mode_serial.tfvars`
2. Bypass mode, switch disabled — `examples/switch_mode_bypass.tfvars`

Each example is a `.tfvars` file so you can run `terraform plan -var-file=...` or `terraform apply -var-file=...`.

## Local testing

1. Add a `main.tf` in the caller directory referencing this module.
2. Run:

```bash
terraform init
terraform plan -var-file=examples/switch_mode_serial.tfvars
terraform apply -var-file=examples/switch_mode_serial.tfvars
```

Notes:

- `subnet_id` is required only when `switch_mode` is `1` (serial) and `enable` is `1` (on); omit it otherwise.
- Ensure your Tencent Cloud credentials have permissions to manage the edge firewall instance and the specified public IP/subnet.
