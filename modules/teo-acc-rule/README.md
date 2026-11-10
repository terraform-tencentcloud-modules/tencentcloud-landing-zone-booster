# EdgeOne L7 Acceleration Rule V2 (teo-acc-rule) Terraform Module

This module creates an **EdgeOne L7 Acceleration Rule V2** (`tencentcloud_teo_l7_acc_rule_v2`) for a given EdgeOne zone. It supports a single top-level rule with one or more **branches**, each containing a **match condition** and a list of **actions**. Branches also support nested **sub-rules** (each with their own branches), enabling hierarchical matching logic.

## Rule structure

```
acc_rule (rule-level metadata)
└── branches[]                  # top-level branches (currently supports a single branch per rule)
    ├── condition                # match expression (see Tencent Cloud docs)
    ├── actions[]                # operations applied when the condition matches
    │   └── <action_name>        # one of the ~35 action types listed below
    │       └── <action_parameters>
    └── sub_rules[]              # nested sub-rules
        ├── description[]
        └── branches[]           # same structure as top-level branches
            ├── condition
            └── actions[]
```

> **Note**: Per the variable description, only **one branch** is supported at the rule level currently. Sub-rules may contain their own branches/actions following the identical schema.

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
| `tencentcloud_teo_l7_acc_rule_v2.acc_rule` | resource |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_edgeone_zone_id"></a> [edgeone\_zone\_id](#input\_edgeone\_zone\_id) | `string` | yes | – | ID of the EdgeOne zone. |
| <a name="input_acc_rule"></a> [acc\_rule](#input\_acc\_rule) | `object` | no | `{ status = "enable" }` | Rule-level metadata (name, description, status). |
| <a name="input_branches"></a> [branches](#input\_branches) | `list(object)` | no | `[]` | Rule branch list. Currently supports filling in only one branch. Each branch has a `condition` and a list of `actions`, plus optional nested `sub_rules`. |

### `acc_rule` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | no | – | Rule name (max 255 characters). |
| `description` | `list(string)` | no | – | Rule annotations (multiple supported). |
| `status` | `string` | no | `"enable"` | Rule status: `enable` / `disable`. |

### `branches` element

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `condition` | `string` | yes | Match condition expression. See [EdgeOne rule conditions](https://www.tencentcloud.com/document/product/1145/54759). |
| `actions` | `list(object)` | no (default `[]`) | List of operations to apply. Each action has a `name` (operation name) and one optional `*_parameters` block matching the operation (see table below). |
| `sub_rules` | `list(object)` | no (default `[]`) | Nested sub-rules. Each: `description` (`list(string)`), `branches` (`list(object)` — same schema as above, `condition` required + optional `actions` + nested `sub_rules`). |

### `actions` — supported operation types

Each action object requires `name` (the operation identifier) and may include one matching `*_parameters` block. All `on`/`off` switches are strings; optional fields fall back to provider defaults when omitted.

| `name` | Parameters block | Key fields (optional unless noted) | Notes |
|--------|------------------|-----------------------------------|-------|
| – | `cache_parameters` | `custom_time` (`cache_time` default `2592000`, `ignore_cache_control` default `off`, `switch` **req**), `follow_origin` (`switch` **req**, `default_cache` default `off`, `default_cache_strategy` default `on`, `default_cache_time` default `0`), `no_cache` (`switch` **req**) | Node cache TTL. |
| – | `cache_key_parameters` | `full_url_cache` (default `on`), `ignore_case` (default `off`), `scheme`, `query_string` (`action`, `switch` default `off`, `values`), `header` (`switch` default `off`, `values`), `cookie` (`action`, `switch` default `off`, `values`) | Custom cache key. |
| – | `cache_prefresh_parameters` | `switch` **req**, `cache_time_percent` (default `90`) | Cache pre-refresh (1–99%). |
| – | `access_url_redirect_parameters` | `status_code` (301/302/303/307/308), `protocol` (http/https/follow), `host_name` (`action` follow/custom, `value`), `url_path` (`action` follow/custom/regex, `value`, `regex`), `query_string` (`action` full/ignore) | Access URL redirection. |
| – | `upstream_url_rewrite_parameters` | `type` (path), `action` (replace/addPrefix/rmvPrefix), `value` (max 1024, starts with `/`), `regex` | Back-to-origin URL rewrite. |
| – | `quic_parameters` | `switch` **req** | QUIC. |
| – | `web_socket_parameters` | `switch` **req**, `timeout` (default `30`, max `120`) | WebSocket. |
| – | `authentication_parameters` | `auth_type` (TypeA/B/C/D/TypeVOD), `secret_key` (6–40), `backup_secret_key` (6–40), `timeout` (1–630720000), `time_format` (dec/hex), `time_param`, `auth_param` | Token authentication. |
| – | `max_age_parameters` | `follow_origin` (default `on`), `cache_time` (default `600`) | Browser cache TTL. |
| – | `status_code_cache_parameters` | `status_code_cache_params[]` (`status_code` ∈ {400,401,403,404,405,407,414,500,501,502,503,504,509,514}, `cache_time` 0–31536000) | Status code cache TTL. |
| – | `offline_cache_parameters` | `switch` **req** | Offline cache. |
| – | `smart_routing_parameters` | `switch` **req** | Smart acceleration. |
| – | `range_origin_pull_parameters` | `switch` **req** | Range origin pull. |
| – | `upstream_http2_parameters` | `switch` **req** | HTTP2 origin-pull. |
| – | `host_header_parameters` | `action` (followOrigin/custom), `server_name` (full domain) | Host header rewrite. |
| – | `force_redirect_https_parameters` | `switch` **req**, `redirect_status_code` (default `302`, 301/302) | Force HTTPS redirect. |
| – | `origin_pull_protocol_parameters` | `protocol` (http/https/follow) | Back-to-origin HTTPS. |
| – | `compression_parameters` | `switch` **req**, `algorithms` (default `["brotli","gzip"]`) | Smart compression. |
| – | `content_compression_parameters` | `switch` **req** | Content compression. |
| – | `hsts_parameters` | `switch` **req**, `timeout` (default `0`, 1–31536000), `include_sub_domains` (default `off`), `preload` (default `off`) | HSTS. |
| – | `client_ip_header_parameters` | `switch` **req**, `header_name` | Client IP header. |
| – | `ocsp_stapling_parameters` | `switch` **req** | OCSP stapling. |
| – | `http2_parameters` | `switch` **req** | HTTP2 access. |
| – | `post_max_size_parameters` | `switch` **req**, `max_size` (default `838860800`, 1·2²⁰–500·2²⁰) | POST upload size limit. |
| – | `client_ip_country_parameters` | `switch` **req**, `header_name` | Client IP country. |
| – | `upstream_follow_redirect_parameters` | `switch` **req**, `max_times` (default `3`, 1–5) | Origin-pull follow redirect. |
| – | `upstream_request_parameters` | `query_string` (`action` full/ignore/includeCustom/excludeCustom, `switch` default `off`, `values`), `cookie` (same as query_string) | Origin-pull request params. |
| – | `tls_config_parameters` | `cipher_suite` (default `loose-v2023`), `version` (default `["TLSv1","TLSv1.1","TLSv1.2","TLSv1.3"]`) | SSL/TLS security. |
| – | `modify_origin_parameters` | `origin_type` (IPDomain/OriginGroup/LoadBalance/COS/AWSS3), `origin`, `origin_protocol` (Http/Https/Follow), `http_origin_port` (1–65535), `https_origin_port` (1–65535), `private_access` (on/off), `private_parameters` (`access_key_id` **req**, `secret_access_key` **req**, `signature_version` **req** v2/v4, `region`) | Modify origin server. |
| – | `http_upstream_timeout_parameters` | `response_timeout` (5–600) | Layer 7 origin timeout. |
| – | `http_response_parameters` | `status_code`, `response_page` | HTTP response. |
| – | `error_page_parameters` | `error_page_params[]` (`status_code` ∈ {400,403,404,405,414,416,451,500,501,502,503,504}, `redirect_url` full path) | Custom error page. |
| – | `modify_response_header_parameters` | `header_actions[]` (`action` set/del/add, `name` **req**, `value`) | Modify response header. |
| – | `modify_request_header_parameters` | `header_actions[]` (`action` set/del/add, `name` **req**, `value`) | Modify request header. |
| – | `response_speed_limit_parameters` | `mode` **req** (LimitUponDownload/LimitAfterSpecificBytesDownloaded/LimitAfterSpecificSecondsDownloaded), `max_speed` **req** (kb/s), `start_at` (kb or s) | Per-connection speed limit. |
| – | `set_content_identifier_parameters` | `content_identifier` | Content identifier. |

> **Legend**: **req** = required field (no default); all `switch`/`on`/`off` values are strings.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rule_id"></a> [rule\_id](#output\_rule\_id) | The rule ID of the acceleration rule. |

## Usage

```hcl
module "teo_acc_rule" {
  source = "./modules/teo-acc-rule"

  edgeone_zone_id = "zone-xxxxxxxx"

  acc_rule = {
    name        = "redirect-and-cache"
    description = ["Example rule for www host"]
    status      = "enable"
  }

  branches = [
    {
      condition = "http.request.uri.path matches \"^/api/.*\""
      actions = [
        {
          name = "Cache"
          cache_parameters = {
            custom_time = {
              switch               = "on"
              cache_time           = 86400
              ignore_cache_control = "off"
            }
          }
        },
        {
          name = "ForceRedirectHTTPS"
          force_redirect_https_parameters = {
            switch               = "on"
            redirect_status_code = 301
          }
        },
        {
          name = "Compression"
          compression_parameters = {
            switch     = "on"
            algorithms = ["brotli", "gzip"]
          }
        }
      ]
      sub_rules = [
        {
          description = ["nested rule for static assets"]
          branches = [
            {
              condition = "http.request.uri.path matches \"\\.css$\""
              actions = [
                {
                  name = "MaxAge"
                  max_age_parameters = {
                    follow_origin = "off"
                    cache_time    = 604800
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```
