# tencentcloud_cfw_address_template module

This Terraform module manages the CFW (Cloud Firewall) address template resource on Tencent Cloud (`tencentcloud_cfw_address_template`). It is a small wrapper around the provider resource to create an IP address template or a domain name template used by firewall rules.

## Directory structure

Common files in this module and their purpose:

- `main.tf` — Module entry, declares the `tencentcloud_cfw_address_template` resource.
- `variables.tf` — Input variable definitions and validation (e.g. `type` must be 1 or 5).
- `outputs.tf` — Exported outputs (resource `id`).
- `versions.tf` — Provider and Terraform version constraints (if present).
- `examples/` — Example `.tfvars` files demonstrating common scenarios.
- `README.md` — Chinese README for the module.
- `README_EN.md` — This English README.

When changing module inputs/outputs, please update `variables.tf` / `outputs.tf` and these READMEs.

## Overview

This module maps the following key inputs:

- `type` (number) — Template type: `1` = IP address template, `5` = domain name template. The module validates the value is 1 or 5.
- `name` (string) — Template name.
- `detail` (string) — Template detail / description.
- `ip_string` (string) — Template content:
  - When `type` is `1`: comma-separated IP addresses, e.g. `1.1.1.1,2.2.2.2`.
  - When `type` is `5`: comma-separated domain names, e.g. `www.qq.com,www.tencent.com`.

The module creates `tencentcloud_cfw_address_template` and exports the resource `id`.

## Variables

See `variables.tf` for full definitions. Summary:

- `type` must be `1` or `5`.
- `name` and `detail` are required strings.
- `ip_string` is required; its format depends on `type` (see Overview).

Example usage:

```hcl
module "cfw_address_template" {
  source   = "../../modules/tencentcloud-cfw-address-template"
  type     = 1
  name     = "tf_example"
  detail   = "test template"
  ip_string = "1.1.1.1,2.2.2.2"
}
```

## Outputs

- `id` — The resource ID from `tencentcloud_cfw_address_template`.

## Examples (in `examples/`)

The module includes a few `.tfvars` example files under `examples/`:

1. `ip-template.tfvars` — Create an IP address template (`type=1`).
2. `domain-template.tfvars` — Create a domain name template (`type=5`).

Run an example:

```bash
terraform init
terraform plan -var-file=modules/tencentcloud-cfw-address-template/examples/ip-template.tfvars
terraform apply -var-file=modules/tencentcloud-cfw-address-template/examples/ip-template.tfvars
```

Notes:

- `type` accepts only `1` (IP template) or `5` (domain name template) — other values are rejected by validation.
- The format of `ip_string` must match `type`: comma-separated IPs for `type=1`, comma-separated domain names for `type=5`.
- Ensure your Tencent Cloud credentials have permissions to manage Cloud Firewall address templates.
- Replace placeholder values in examples with real values before running `apply`.
