# tencentcloud-waf-saas-ip-access-control module

This Terraform module provisions a WAF SaaS IP access control rule on Tencent Cloud using the `tencentcloud_waf_saas_ip_access_control` resource.

## Overview

The module wraps common configuration for `tencentcloud_waf_saas_ip_access_control`, making it easy to reuse across environments. Use it to configure IP whitelist/blacklist rules for WAF SaaS domains, implementing access control for specific IP addresses with support for scheduled configurations.

## Directory structure

The following lists common files and their purpose within this module to help you quickly find and modify items:

- `main.tf` — The module entry; declares the `tencentcloud_waf_saas_ip_access_control` resource and its configuration.
- `variables.tf` — Input variable definitions (types, defaults, sensitive flags).
- `outputs.tf` — Module outputs (expose resource ID and rule ID).
- `versions.tf` — Terraform and provider version constraints to ensure compatibility.
- `examples/` — Example usages and `*.tfvars` files illustrating common scenarios.
- `README.md` — Chinese documentation for the module.
- `README_EN.md` — English documentation (this file).

When changing module inputs or outputs, please update the corresponding `variables.tf` / `outputs.tf` and documentation to keep them in sync.

## Inputs (Variables)

The variables are defined in `variables.tf`. Required and optional inputs are listed below.

### Required variables
- `instance_id` (string) — WAF instance ID.
- `domain` (string) — Domain to apply the rule to.
- `ip_list` (list(string)) — List of IPs or CIDRs to control.
- `action_type` (number) — Access control type: 42: blocklist; 40: allowlist.

### Optional variables (with defaults)
- `description` (string, default null) — Rule description.
- `job_date_time` (list(object), default []) — Scheduled configuration details.
  - `cron` (list(object)) — Time parameters for periodic execution
    - `days` (set(number)) — Days in each month for execution
    - `end_time` (string) — End time
    - `start_time` (string) — Start time
    - `w_days` (set(number)) — Days of each week for execution
  - `time_t_zone` (string) — Time zone
  - `timed` (list(object)) — Time parameters for scheduled execution
    - `end_date_time` (number) — End timestamp (seconds)
    - `start_date_time` (number) — Start timestamp (seconds)
- `job_type` (string, default null) — Scheduled configuration type.
- `note` (string, default null) — Remarks.

## Outputs

The module exports the following output values:

- `id` — Resource ID
- `rule_id` — IP access control rule ID

## Examples

Below are example configurations for common scenarios:

### 1) Basic IP Blocklist Configuration

```hcl
module "waf_ip_access_control_blacklist" {
  source      = "../../modules/tencentcloud-waf-saas-ip-access-control"
  instance_id = "waf-instance-xxxx"
  domain      = "example.com"
  ip_list     = ["192.168.1.100", "10.0.0.0/24"]
  action_type = 42  # blocklist
  description = "Block malicious IP addresses"
}
```

Use case: Block specific IPs or IP ranges from accessing your website.

### 2) IP Allowlist Configuration

```hcl
module "waf_ip_access_control_whitelist" {
  source      = "../../modules/tencentcloud-waf-saas-ip-access-control"
  instance_id = "waf-instance-xxxx"
  domain      = "api.example.com"
  ip_list     = ["203.0.113.10", "203.0.113.20"]
  action_type = 40  # allowlist
  description = "Allow only internal API calling IPs"
}
```

Use case: Restrict API access to specific IP addresses only.

### 3) Scheduled Blocklist Configuration

```hcl
module "waf_ip_access_control_scheduled" {
  source      = "../../modules/tencentcloud-waf-saas-ip-access-control"
  instance_id = "waf-instance-xxxx"
  domain      = "example.com"
  ip_list     = ["198.51.100.50", "198.51.100.51"]
  action_type = 42  # blocklist
  description = "Block abnormal access IPs during working hours"
  job_type    = "cron"
  
  job_date_time = [{
    cron = [{
      days      = [1, 15, 30]  # Execute on 1st, 15th, 30th of each month
      end_time  = "18:00:00"
      start_time = "09:00:00"
      w_days    = [1, 2, 3, 4, 5]  # Monday to Friday
    }]
    time_t_zone = "Asia/Shanghai"
  }]
}
```

Use case: Block IPs during specific time periods.

### 4) Multiple IP Range Control

```hcl
module "waf_ip_access_control_multiple" {
  source      = "../../modules/tencentcloud-waf-saas-ip-access-control"
  instance_id = "waf-instance-xxxx"
  domain      = "example.com"
  ip_list     = ["192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
  action_type = 40  # allowlist
  description = "Allow internal network access"
}
```

Use case: Control access permissions for entire IP ranges.

## Scheduled Configuration Details

### cron Scheduled Configuration
- `days`: Specify days of the month for execution (1-31)
- `w_days`: Specify days of the week for execution (1-7, 1=Sunday, 7=Saturday)
- `start_time`: Rule activation start time (HH:MM:SS format)
- `end_time`: Rule activation end time (HH:MM:SS format)

### timed Scheduled Configuration
- `start_date_time`: Rule activation start timestamp (seconds)
- `end_date_time`: Rule activation end timestamp (seconds)

## Common Scenarios & Recommendations

- **Security Protection**: Use `action_type = 42` (blocklist) to block known malicious IPs from accessing your website.
- **API Protection**: Use `action_type = 40` (allowlist) to restrict API access to specific IP addresses only.
- **Working Hours Control**: Combine with scheduled configuration to enable access control rules during specific time periods.
- **IP Range Management**: Support CIDR notation for managing access permissions for entire IP ranges.
- **Temporary Blocking**: Use scheduled configuration for temporary IP blocking.

## Notes

- Ensure the WAF instance specified by `instance_id` has permission to manage IP access control rules for the target domain.
- `ip_list` supports both single IP addresses (e.g., `192.168.1.1`) and CIDR notation (e.g., `192.168.1.0/24`).
- Multiple IP access control rules can be configured for the same domain, with rules taking effect in creation order.
- Scheduled configurations require accurate time parameters to avoid incorrect rule activation times.
- Test scheduled configurations in a test environment before deploying to production.