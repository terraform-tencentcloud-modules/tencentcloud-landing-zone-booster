# EdgeOne (TEO) Terraform Module

This module manages an **EdgeOne (TEO) Zone** and its **L7 acceleration settings** (`tencentcloud_teo_zone` + `tencentcloud_teo_l7_acc_setting`).

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6 |
| tencentcloud | >= 1.81.136 |

## Providers

| Provider | Source |
|----------|--------|
| tencentcloud | tencentcloudstack/tencentcloud |

## Resources

| Name | Type |
|------|------|
| `tencentcloud_teo_zone.zone` | resource |
| `tencentcloud_teo_l7_acc_setting.l7_acc_setting` | resource (created only when `l7_acc_setting` is non-empty) |

> **Note**: The L7 acceleration setting resource is created conditionally. When `var.l7_acc_setting` is an empty list (`[]`), no `tencentcloud_teo_l7_acc_setting` resource is provisioned, but `zone_config` is still required by the resource — so the list should contain exactly one element (or be empty) when provided.

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_edgeone_zone"></a> [edgeone\_zone](#input\_edgeone\_zone) | `object` | yes | – | EdgeOne zone configuration. See the structure below. |
| <a name="input_l7_acc_setting"></a> [l7\_acc\_setting](#input\_l7\_acc\_setting) | `list(object)` | no | `[]` | EdgeOne L7 acceleration setting configuration (single-element list). All sub-fields are optional with sensible defaults. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags to associate with the zone. |

### `edgeone_zone` object

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `zone_name` | `string` | yes | Site domain name. |
| `type` | `string` | yes | Site access type. `partial` (CNAME, default), `full` (NS), `noDomainAccess` (no domain access). |
| `area` | `string` | yes | Availability zone area. `global` / `mainland` (Chinese mainland) / `overseas` (outside Chinese mainland). |
| `plan_id` | `string` | yes | Target Plan ID to bind the zone to. |
| `alias_zone_name` | `string` | no | Alias site identifier (numbers, English, `-` and `_`, max 20 chars). |
| `paused` | `bool` | no | Whether the site is disabled. Default `false`. |

### `l7_acc_setting` list element

Each entry supports the following optional sub-objects (only provided ones are applied):

| Sub-object | Key fields (optional) | Notes |
|------------|----------------------|-------|
| `accelerate_mainland` | `switch` (on/off) | Accelerate the Chinese mainland. |
| `cache` | `custom_time` (`cache_time` default `2592000`, `switch`), `follow_origin` (`switch`, `default_cache` default `off`, `default_cache_strategy` default `on`, `default_cache_time` default `0`), `no_cache` (`switch`) | Caching behavior. |
| `cache_key` | `full_url_cache` (default `on`), `ignore_case` (default `off`), `query_string` (`action`, `switch` default `off`, `values`) | Cache key rules. |
| `cache_prefresh` | `switch`, `cache_time_percent` (default `90`) | Cache prefresh. |
| `client_ip_country` | `switch`, `header_name` | Client IP country header. |
| `client_ip_header` | `switch`, `header_name` | Client IP header. |
| `compression` | `switch`, `algorithms` (default `["brotli", "gzip"]`) | Compression. |
| `force_redirect_https` | `switch`, `redirect_status_code` (default `302`) | Force HTTPS redirect. |
| `grpc` | `switch` | gRPC support. |
| `hsts` | `switch`, `include_sub_domains` (default `off`), `preload` (default `off`), `timeout` (default `0`) | HSTS. |
| `http2` | `switch` | HTTP/2. |
| `ipv6` | `switch` | IPv6. |
| `max_age` | `follow_origin` (default `on`), `cache_time` (default `600`) | Max age. |
| `ocsp_stapling` | `switch` | OCSP stapling. |
| `offline_cache` | `switch` | Offline cache. |
| `post_max_size` | `switch`, `max_size` (default `838860800`) | Max POST size. |
| `quic` | `switch` | QUIC. |
| `smart_routing` | `switch` | Smart routing. |
| `standard_debug` | `switch`, `allow_client_ip_list` (default `[]`), `expires` | Standard debug. |
| `tls_config` | `cipher_suite` (default `loose-v2023`), `version` (default `["TLSv1","TLSv1.1","TLSv1.2","TLSv1.3"]`) | TLS configuration. |
| `upstream_http2` | `switch` | Upstream HTTP/2. |
| `web_socket` | `switch`, `timeout` (default `30`) | WebSocket. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | ID of the EdgeOne Zone. |
| <a name="output_zone_ownership_verification"></a> [zone\_ownership\_verification](#output\_zone\_ownership\_verification) | Ownership verification information. |
| <a name="output_zone_status"></a> [zone\_status](#output\_zone\_status) | Site status. |
| <a name="output_l7_acc_setting_id"></a> [l7\_acc\_setting\_id](#output\_l7\_acc\_setting\_id) | ID of the L7 acceleration setting (null when `l7_acc_setting` is empty). |

## Usage

```hcl
module "teo" {
  source = "./modules/teo"

  tags = {
    env = "prod"
  }

  edgeone_zone = {
    zone_name = "example.com"
    type      = "partial"   # CNAME access
    area      = "overseas"
    plan_id   = "edgeone-xxxxxxxx"
    paused    = false
  }

  l7_acc_setting = [
    {
      accelerate_mainland = {
        switch = "on"
      }
      cache = {
        custom_time = {
          switch     = "on"
          cache_time = 2592000
        }
        follow_origin = {
          switch                 = "on"
          default_cache          = "off"
          default_cache_strategy = "on"
          default_cache_time     = 0
        }
      }
      cache_key = {
        full_url_cache = "on"
        ignore_case    = "off"
        query_string = {
          action = "excludeCustom"
          switch = "on"
          values = ["utm_source", "utm_medium"]
        }
      }
      compression = {
        switch     = "on"
        algorithms = ["brotli", "gzip"]
      }
      force_redirect_https = {
        switch               = "on"
        redirect_status_code = 302
      }
      hsts = {
        switch              = "on"
        include_sub_domains = "on"
        preload             = "off"
        timeout             = 31536000
      }
      http2      = { switch = "on" }
      ipv6       = { switch = "on" }
      quic       = { switch = "on" }
      smart_routing = { switch = "on" }
      tls_config = {
        cipher_suite = "loose-v2023"
        version      = ["TLSv1.2", "TLSv1.3"]
      }
      web_socket = {
        switch  = "on"
        timeout = 60
      }
    }
  ]
}
```

### Minimal configuration (zone only, no L7 acceleration settings)

```hcl
module "teo" {
  source = "./modules/teo"

  edgeone_zone = {
    zone_name = "example.com"
    type      = "partial"
    area      = "overseas"
    plan_id   = "edgeone-xxxxxxxx"
  }

  # l7_acc_setting defaults to [] → the L7 acceleration setting resource is not created
}
```
