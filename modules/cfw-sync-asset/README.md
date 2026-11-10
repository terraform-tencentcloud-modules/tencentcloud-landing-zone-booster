# tencentcloud_cfw_sync_asset module

This Terraform module manages the CFW (Cloud Firewall) asset synchronization resource on Tencent Cloud (`tencentcloud_cfw_sync_asset`). It is a lightweight wrapper around the provider resource that triggers a synchronization of cloud assets into the Cloud Firewall.

## Overview

It creates the `tencentcloud_cfw_sync_asset` resource. This resource takes no arguments and exposes no attributes — applying it synchronizes assets (e.g. VPC, subnet, CVM, ENI, etc.) into the Cloud Firewall. The module does not require any input variables and does not export any outputs.

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_sync_asset` resource.
- `variables.tf` — Input variable definitions (empty for this module; no inputs are required).
- `outputs.tf` — Exported outputs (empty for this module; no outputs are exposed).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `README.md` — Chinese README for the module.
- `README_EN.md` — English README for the module (this file).

When you change the module (add variables, outputs, or examples), please update `variables.tf` / `outputs.tf` and these READMEs accordingly to keep documentation in sync.

## Variables

This module does not require any input variables. `variables.tf` is intentionally empty.

Example usage:

```hcl
module "cfw_sync_asset" {
  source = "../../modules/tencentcloud-cfw-sync-asset"
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

- `tencentcloud_cfw_sync_asset` takes no arguments; `terraform apply` synchronizes the assets into the Cloud Firewall.
- Ensure your Tencent Cloud credentials have permissions to manage the Cloud Firewall and read the related asset information.
