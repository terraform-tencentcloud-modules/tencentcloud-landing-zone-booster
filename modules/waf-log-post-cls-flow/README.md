# tencentcloud-waf-log-post-cls-flow module

This Terraform module configures forwarding of WAF logs to Tencent Cloud CLS (Cloud Log Service) using the `tencentcloud_waf_log_post_cls_flow` resource.

## Overview

The module exposes a small set of optional inputs (defaults are provided) to quickly enable delivery of WAF access or attack logs to CLS. Typical use cases include centralized logging, auditing, analytics pipelines, and alerting.

## Directory structure

- `main.tf` — Resource declaration for `tencentcloud_waf_log_post_cls_flow`.
- `variables.tf` — Module input variables (defaults and validation).
- `outputs.tf` — Module outputs (`id`, `flow_id`, `log_topic_id`, `logset_id`, `status`).
- `examples/` — Example `*.tfvars` files for quick testing.
- `README.md` — Chinese documentation.
- `README_EN.md` — English documentation (this file).

## Inputs (Variables)

All inputs in this module are optional and have sensible defaults:

- `cls_region` (string, default `ap-shanghai`) — CLS region to deliver logs to.
- `log_topic_name` (string, default `waf_post_logtopic`) — CLS log topic name.
- `log_type` (number, default `1`) — Log type: 1 = access logs, 2 = attack logs.
- `logset_name` (string, default `waf_post_logset`) — CLS logset name.

Override defaults when you need a specific region or when your CLS resources follow a naming convention.

## Outputs

- `id` — Terraform resource id.
- `flow_id` — Unique flow id for the CLS delivery configuration.
- `log_topic_id` — CLS log topic id.
- `logset_id` — CLS logset id.
- `status` — Delivery status: 0 = off, 1 = on.

## Examples

The `examples/` directory contains `.tfvars` files for common scenarios (replace placeholders with actual values where applicable):

1) Basic — `examples/basic.tfvars` (default access logs)
2) Attack logs — `examples/attack_log.tfvars` (log_type = 2)
3) Custom names — `examples/custom_names.tfvars` (override topic and logset names)
4) Different region — `examples/region.tfvars` (set `cls_region` to another region)

## Usage

Call the module in your root module and optionally use a `-var-file` pointing to one of the examples:

```hcl
module "waf_cls_flow" {
  source = "../../modules/tencentcloud-waf-log-post-cls-flow"

  # optional overrides
  # cls_region    = "ap-guangzhou"
  # log_topic_name = "my_waf_topic"
  # log_type      = 2
  # logset_name   = "my_waf_logset"
}
```

Test with an example var file:

```bash
terraform init
terraform plan -var-file=examples/basic.tfvars
terraform apply -var-file=examples/basic.tfvars
```

Be cautious: applying will create real delivery configuration and may produce downstream traffic; test in non-production first.

## Troubleshooting

- If logs are not arriving, verify `flow_id`, CLS topic/logset existence and permissions, and network reachability to CLS endpoints.
- Ensure the `log_topic_name`/`logset_name` you provide exist and that your account has write permissions.

