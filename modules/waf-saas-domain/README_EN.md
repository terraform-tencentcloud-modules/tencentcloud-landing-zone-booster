# tencentcloud-waf-saas-domain module

This Terraform module provisions a WAF SaaS domain on Tencent Cloud using the `tencentcloud_waf_saas_domain` resource.

## Overview

The module wraps common configuration for `tencentcloud_waf_saas_domain`, making it easy to reuse across environments. Use it to attach a domain to a WAF instance and configure listening ports, upstream settings, certificates, and related policies.

## Directory structure

The following lists common files and their purpose within this module to help you quickly find and modify items:

- `main.tf` — The module entry; declares the `tencentcloud_waf_saas_domain` resource and its configuration.
- `variables.tf` — Input variable definitions (types, defaults, sensitive flags).
- `outputs.tf` — Module outputs (if present, expose domain id, ssl id, etc.). Update or add outputs as needed.
- `versions.tf` — Terraform and provider version constraints to ensure compatibility.
- `examples/` — Example usages and `*.tfvars` files (if present) illustrating common scenarios.
- `README.md` — Chinese documentation for the module.
- `README_EN.md` — English documentation (this file).

When changing module inputs or outputs, please update the corresponding `variables.tf` / `outputs.tf` and documentation to keep them in sync.

## Inputs (Variables)

The variables are defined in `variables.tf`. Required and optional inputs are listed below.

- `domain` (string) — Required. The domain name.
- `instance_id` (string) — Required. WAF instance ID.
- `ports` (list(object)) — Required. A list of port configurations. Each entry contains:
  - `port` (string) — listen port
  - `protocol` (string) — protocol (e.g. `http`/`https`)
  - `upstream_port` (string) — upstream port
  - `upstream_protocol` (string) — upstream protocol

Optional variables (with defaults):

- `active_check` (number, default 0) — Enable active health check (0 off, 1 on).
- `api_safe_status` (number, default 0) — API protection (1 on, 0 off).
- `bot_status` (number, default 0) — Bot control (1 on, 0 off).
- `cert_type` (number, default 0) — Certificate type: 0 none; 1 self-owned; 2 managed.
- `cert` (string, sensitive, default null) — Certificate content (when cert_type=1).
- `private_key` (string, sensitive, default null) — Certificate private key (when cert_type=1).
- `ssl_id` (string, default null) — Managed certificate ID (when cert_type=2).
- `cipher_template` (number, default 0) — Cipher template (0 default, 1 universal, 2 secure, 3 custom).
- `ciphers` (list(number), default []) — Cipher list (when using custom template).
- `cls_status` (number, default 0) — Enable access logs (1 on, 0 off).
- `https_rewrite` (number, default 0) — Enable HTTP->HTTPS redirect (1 on, 0 off).
- `https_upstream_port` (string, default null) — Upstream port for HTTPS (special cases).
- `ip_headers` (list(string), default []) — Custom client IP headers (when is_cdn=3).
- `is_cdn` (number, default 0) — CDN deployment mode (0 none, 1 X-Forwarded-For first, 2 remote_addr, 3 custom headers).
- `is_http2` (number, default 0) — Enable HTTP/2 (requires HTTPS, 1 on, 0 off).
- `is_keep_alive` (string, default "0") — Keep-alive ("0" off, "1" on).
- `is_websocket` (number, default 0) — WebSocket support (1 on, 0 off).
- `load_balance` (string, default "0") — Load balancing strategy ("0" round-robin, "1" IP hash, "2" weighted round-robin).
- `proxy_read_timeout` (number, default 300) — Proxy read timeout (seconds).
- `proxy_send_timeout` (number, default 300) — Proxy send timeout (seconds).
- `sni_host` (string, default null) — Custom SNI host (when sni_type=3).
- `sni_type` (number, default 0) — Upstream SNI type (0 disable, 1 use original request host, 2 use upstream host, 3 custom host).
- `src_list` (list(string), default []) — Upstream IP list (when upstream_type=0).
- `upstream_domain` (string, default null) — Upstream domain (when upstream_type=1).
- `upstream_scheme` (string, default "http") — Upstream scheme (`http` or `https`).
- `upstream_type` (number, default 0) — Upstream type (0 IP, 1 domain).
- `weights` (list(number), default []) — Weights for upstreams (matching `src_list`).
- `xff_reset` (number, default 0) — Reset X-Forwarded-For (0 off, 1 on).
- `status` (number, default 1) — WAF switch (1 on, 0 off).
- `tls_version` (number, default 1.2) — TLS protocol version.

> Note: `cert` and `private_key` are marked sensitive in `variables.tf`. Provide them through secure variable storage (Terraform Cloud/Enterprise variable, Vault, etc.).

## Outputs

There is no `outputs.tf` in the module directory at the moment, so the module does not export explicit outputs. Add an `outputs.tf` if you need to expose values like domain ID or ssl_id.

## Examples

Below are example `*.tfvars` files in `examples/` matching the examples in the Chinese README.

### 1) Minimal (HTTP)

See `examples/basic.tfvars`.

### 2) Managed certificate (HTTPS)

See `examples/https.tfvars`.

### 3) Self-owned certificate + custom SNI + upstream domain

See `examples/custom_cert.tfvars`. Be careful: `cert` and `private_key` are sensitive; do not commit real keys to source control.

### 4) Multiple backends (IP list) with weighted load

See `examples/multi_backend.tfvars`.

## Common scenarios & recommendations

- If WAF is placed behind a CDN, configure `is_cdn` and `ip_headers` correctly to ensure the module obtains the real client IP:
  - CDN using X-Forwarded-For first item: `is_cdn = 1`
  - CDN using remote_addr: `is_cdn = 2`
  - Custom header(s): `is_cdn = 3` and set `ip_headers`.

- Prefer managed certificates (`cert_type=2`) to reduce private key handling risks. If using self-owned certificates, store them securely.

- If enabling HTTP/2 (`is_http2=1`), you must use HTTPS (listen on 443).

- Tune `proxy_read_timeout` and `proxy_send_timeout` to fit backend response times to avoid 502/504.

- Enable `cls_status = 1` to send access logs to Cloud Log Service for troubleshooting and auditing.

## Notes

- Add an `outputs.tf` to the module if you want to expose attributes (domain id, ssl id, etc.) to the caller.
- Ensure `instance_id` has required permissions to manage domains in the WAF instance.

## Quick local test

1. Copy one of the `examples/*.tfvars` to your working directory (or reference it with `-var-file`).
2. Run `terraform init`.
3. Run `terraform plan -var-file=examples/basic.tfvars` (replace file name as needed).
4. Run `terraform apply -var-file=examples/basic.tfvars` to create resources.
