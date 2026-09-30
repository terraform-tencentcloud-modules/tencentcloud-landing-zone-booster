# tencentcloud-waf-log-post-ckafka-flow module

This Terraform module configures forwarding of WAF logs to CKafka using the `tencentcloud_waf_log_post_ckafka_flow` resource.

## Overview

The module accepts CKafka connection information, topic, compression and Kafka version parameters, and supports optional SASL authentication and fine-grained `write_config` controls (to enable body/bot/headers fields). Typical uses include streaming WAF access/attack logs into CKafka for analytics, monitoring or downstream processing.

## Directory structure

- `main.tf` — Resource declaration for `tencentcloud_waf_log_post_ckafka_flow`.
- `variables.tf` — Module inputs (required and optional), validation rules and sensitive flags.
- `outputs.tf` — Module outputs (`id`, `flow_id`, `status`).
- `examples/` — Example `*.tfvars` files for quick testing (replace placeholder values).
- `README.md` — Chinese documentation.
- `README_EN.md` — This file.

When changing module inputs/outputs, update the docs and examples as well.

## Inputs (Variables)

Required:

- `brokers` (string) — CKafka broker addresses (IP:PORT or domain:PORT).
- `ckafka_id` (string) — CKafka instance ID.
- `ckafka_region` (string) — Region where the CKafka instance is located.
- `compression` (string) — Compression type: `none`, `snappy`, `gzip`, `lz4` (recommended `snappy`).
- `kafka_version` (string) — Kafka cluster version.
- `log_type` (number) — Log type: 1 = access log, 2 = attack log.
- `topic` (string) — Topic name (default `waf_post_access_log`).
- `vip_type` (number) — 1 = external TGW, 2 = support environment (default 2).

Optional:

- `sasl_enable` (number) — Enable SASL (0 = off, 1 = on).
- `sasl_user` (string) — SASL username.
- `sasl_password` (string, sensitive) — SASL password (sensitive; inject via secure mechanism).
- `write_config` (list(object)) — Control which fields to include (enable_body, enable_bot, enable_headers).

## Outputs

- `id` — Terraform resource ID.
- `flow_id` — Unique flow ID for the log post configuration.
- `status` — Status: 0 = off, 1 = on.

## Examples

The `examples/` folder includes `.tfvars` for typical scenarios. Replace placeholders before applying.

1) Basic — `examples/basic.tfvars` (access log, no SASL, default write_config)
2) Attack logs — `examples/attack_log.tfvars` (log_type=2)
3) SASL auth — `examples/sasl.tfvars` (sasl_enable=1, sensitive password)
4) Custom write_config — `examples/write_config.tfvars` (enable body/headers/bot)

## Usage

Call the module and pass variables; you can use `-var-file` to point to an example:

```hcl
module "waf_ckafka_flow" {
  source = "../../modules/tencentcloud-waf-log-post-ckafka-flow"
  brokers       = var.brokers
  ckafka_id     = var.ckafka_id
  ckafka_region = var.ckafka_region
  compression   = var.compression
  kafka_version = var.kafka_version
  log_type      = var.log_type
  topic         = var.topic
  vip_type      = var.vip_type

  sasl_enable   = var.sasl_enable
  sasl_user     = var.sasl_user
  sasl_password = var.sasl_password
  write_config  = var.write_config
}
```

Quick test:

```bash
terraform init
terraform plan -var-file=examples/basic.tfvars
terraform apply -var-file=examples/basic.tfvars
```

Be careful: apply will create real configuration and possible downstream traffic; use test instances where appropriate.

## Troubleshooting

- Ensure `compression` is supported by your CKafka cluster.
- If SASL is enabled, verify credentials and cluster auth configuration.
- If no logs are received, check `flow_id`, CKafka topic permissions and network connectivity (broker reachability, ports, and ACLs).
