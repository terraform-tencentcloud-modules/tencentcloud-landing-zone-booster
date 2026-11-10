# tencentcloud_cfw_sync_route module

This Terraform module manages the CFW (Cloud Firewall) route synchronization resource on Tencent Cloud (`tencentcloud_cfw_sync_route`). It is a lightweight wrapper around the provider resource that triggers a synchronization of firewall routes (e.g. for NAT firewall or inter-VPC firewall) into the Cloud Firewall.

## Overview

The module exposes two input variables:

- `sync_type` (string, optional, default `"Route"`) — Synchronization operation type. `Route` means synchronize firewall routing.
- `fw_type` (string, optional, default `null`) — Firewall type. `nat` = NAT firewall; `ew` = inter-VPC (east-west) firewall.

It creates the `tencentcloud_cfw_sync_route` resource. This module does not export any outputs (`outputs.tf` is intentionally empty).

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_sync_route` resource.
- `variables.tf` — Input variable definitions and default values.
- `outputs.tf` — Exported outputs (empty for this module; no outputs are exposed).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `README.md` — Chinese README for the module.
- `README_EN.md` — English README for the module (this file).

When you change the module (add variables, outputs, or examples), please update `variables.tf` / `outputs.tf` and these READMEs accordingly to keep documentation in sync.

## Variables

From `variables.tf`:

- `sync_type` (string) — Optional, default `"Route"`. Synchronization operation type; `Route` synchronizes firewall routing.
- `fw_type` (string) — Optional, default `null`. Firewall type: `nat` = NAT firewall, `ew` = inter-VPC (east-west) firewall.

Example usage:

```hcl
module "cfw_sync_route" {
  source   = "../../modules/tencentcloud-cfw-sync-route"
  sync_type = "Route"
  fw_type   = "nat"
}
```

## Outputs

This module does not export any outputs. `outputs.tf` is intentionally empty.

## Examples (in `examples/`)

This module does not ship example `.tfvars` files. To use it, simply declare the module in your configuration as shown above.

## Local testing

1. Add a `main.tf` in the caller directory referencing this module.
2. Run:

```bash
terraform init
terraform plan
terraform apply
```

Notes:

- `sync_type` defaults to `"Route"`; for now `Route` is the supported synchronization operation.
- `fw_type` selects the target firewall: `nat` for NAT firewall or `ew` for inter-VPC firewall. Leave it as `null` to use the provider default.
- Ensure your Tencent Cloud credentials have permissions to manage the Cloud Firewall and read the related routing information.
