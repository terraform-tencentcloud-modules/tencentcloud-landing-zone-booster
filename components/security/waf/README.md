# Tencent Cloud Web Application Firewall (WAF) Component

Terraform component under `components/security/waf` for deploying and managing the Web Application Firewall (WAF) service in Tencent Cloud — as part of the `security` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component deploys and manages the Web Application Firewall (WAF) service, providing comprehensive web application security protection. Main features:

- **WAF instance management** – create and manage CLB-type WAF instances, supporting multiple editions (Premium, Enterprise, Ultimate).
- **Domain protection** – configure domain-level WAF protection policies and load-balancer binding.
- **Elastic billing** – elastic QPS billing that scales on demand.
- **API security** – protect API endpoints at the interface level.
- **Bot management** – intelligently identify and block malicious bot traffic.
- **Log delivery** – deliver access logs and attack logs to the CLS service.
- **Attack log config** – configure attack-log delivery and management.
- **Multi-LB support** – CLB, APISIX, TSEGW, and other load balancers.
- **Traffic mode** – cleaning mode and mirroring mode for traffic handling.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.82.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.82.61 |

### IAM Permissions

The executing principal needs the following Tencent Cloud permissions:

| Permission | Description |
|------------|-------------|
| `QcloudFinanceFullAccess` | Financial management access |
| `QcloudBillingReadOnlyAccess` | Billing read-only access |
| `QcloudWAFReadOnlyAccess` | WAF read-only access |
| `QcloudWAFFullAccess` | Full access to WAF |
| `QcloudCLBReadOnlyAccess` | CLB read-only access |
| `QcloudCLSFullAccess` | CLS log service access |

### Prerequisites

- Decide the WAF instance edition (Premium / Enterprise / Ultimate).
- Plan domain protection config and load-balancer binding.
- Decide the QPS limit and elastic billing mode.
- Configure API security and Bot management.
- Plan CLS log delivery configuration.
- Decide the attack-log delivery strategy.
- Prepare load-balancer related info.
- Decide region and availability zone configuration.

---

## Inputs

### WAF instance configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_goods_category"></a> [goods\_category](#input\_goods\_category) | `string` | no | `premium_clb` | Billing order parameter: `premium_clb` (Premium), `enterprise_clb` (Enterprise), `ultimate_clb` (Ultimate). |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | `string` | no | `""` | WAF instance name. |
| <a name="input_time_span"></a> [time\_span](#input\_time\_span) | `number` | no | `1` | Purchase duration. |
| <a name="input_time_unit"></a> [time\_unit](#input\_time\_unit) | `string` | no | `m` | Time unit: `d` (day), `m` (month), `y` (year). |
| <a name="input_auto_renew_flag"></a> [auto\_renew\_flag](#input\_auto\_renew\_flag) | `number` | no | `1` | Auto-renewal flag: `1` enable, `0` disable. |
| <a name="input_elastic_mode"></a> [elastic\_mode](#input\_elastic\_mode) | `number` | no | `1` | Elastic billing mode: `1` enable, `0` disable. |
| <a name="input_qps_limit"></a> [qps\_limit](#input\_qps\_limit) | `number` | no | `200000` | QPS limit, min `10000`. Only settable when `elastic_mode = 1`. |
| <a name="input_api_security"></a> [api\_security](#input\_api\_security) | `number` | no | `0` | API security: `1` enable, `0` disable. |
| <a name="input_bot_management"></a> [bot\_management](#input\_bot\_management) | `number` | no | `0` | Bot management: `1` enable, `0` disable. |

### Domain configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_domain_configs"></a> [domain\_configs](#input\_domain\_configs) | `list(object)` | no | `[]` | List of domain protection configuration objects. |

#### `domain_configs` object fields

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `domain` | `string` | **yes** | – | Domain name. |
| `region` | `string` | **yes** | – | Region of the bound load balancer. |
| `is_cdn` | `number` | no | `0` | Whether a proxy was enabled before WAF: `1` yes, `0` no. |
| `status` | `number` | no | `1` | Binding status between WAF and LB: `0` not bound, `1` binding. |
| `engine` | `number` | no | `20` | Protection status. |
| `flow_mode` | `number` | no | `1` | Traffic mode: `0` mirroring mode, `1` cleaning mode. |
| `alb_type` | `string` | no | `clb` | Load balancer type: `clb`, `apisix`, `tsegw`. |
| `bot_status` | `number` | no | `0` | Bot protection: `1` enable, `0` disable. |
| `api_safe_status` | `number` | no | `0` | API security: `1` enable, `0` disable. |
| `ip_headers` | `list(string)` | no | `[]` | Custom IP headers (required when `is_cdn = 3`). |
| `load_balancer_set` | `list(object)` | no | `[]` | List of bound load balancers. |

#### `load_balancer_set` object fields

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `load_balancer_id` | `string` | **yes** | – | Load balancer unique ID. |
| `load_balancer_name` | `string` | **yes** | – | Load balancer name. |
| `listener_id` | `string` | **yes** | – | Unique ID of the listener. |
| `listener_name` | `string` | **yes** | – | Listener name. |
| `vport` | `number` | **yes** | – | Load balancer port. |
| `protocol` | `string` | **yes** | – | Protocol: `http`, `https`. |
| `region` | `string` | **yes** | – | Load balancer region. |
| `zone` | `string` | **yes** | – | Load balancer availability zone. |
| `vip` | `string` | no | – | Load balancer IP. |
| `load_balancer_type` | `string` | no | – | Network type of the load balancer. |

### CLS log delivery configuration

> ⚠️ **Important**: The CLS log delivery flow resource is created **only when `enable_cls_log = true`**. Simply setting `cls_region` / `log_type` / etc. without enabling `enable_cls_log` will not deliver any logs.

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_enable_cls_log"></a> [enable\_cls\_log](#input\_enable\_cls\_log) | `bool` | no | `false` | Enable CLS log delivery. Must be `true` for the delivery flow to be created. |
| <a name="input_cls_region"></a> [cls\_region](#input\_cls\_region) | `string` | no | `ap-shanghai` | Region where CLS is delivered. |
| <a name="input_logset_name"></a> [logset\_name](#input\_logset\_name) | `string` | no | `waf_post_logset` | Name of the CLS log set. |
| <a name="input_log_topic_name"></a> [log\_topic\_name](#input\_log\_topic\_name) | `string` | no | `waf_post_logtopic` | Name of the CLS log topic. |
| <a name="input_log_type"></a> [log\_type](#input\_log\_type) | `number` | no | `1` | Log type: `1` access log, `2` attack log. Must be `1` or `2`. |

### Attack log configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_attack_log_post"></a> [attack\_log\_post](#input\_attack\_log\_post) | `number` | no | `0` | Attack-log delivery switch: `0` disable, `1` enable. Must be `0` or `1`. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_waf_clb_id"></a> [waf\_clb\_id](#output\_waf\_clb\_id) | WAF CLB instance resource ID. |
| <a name="output_waf_clb_instance_id"></a> [waf\_clb\_instance\_id](#output\_waf\_clb\_instance\_id) | WAF CLB instance ID. |
| <a name="output_waf_clb_edition"></a> [waf\_clb\_edition](#output\_waf\_clb\_edition) | WAF CLB instance edition. |
| <a name="output_waf_clb_status"></a> [waf\_clb\_status](#output\_waf\_clb\_status) | WAF CLB instance status. |
| <a name="output_waf_clb_begin_time"></a> [waf\_clb\_begin\_time](#output\_waf\_clb\_begin\_time) | WAF CLB instance begin time. |
| <a name="output_waf_clb_valid_time"></a> [waf\_clb\_valid\_time](#output\_waf\_clb\_valid\_time) | WAF CLB instance valid (expiry) time. |
| <a name="output_domain_instance_ids"></a> [domain\_instance\_ids](#output\_domain\_instance\_ids) | IDs of WAF CLB domain resources. |
| <a name="output_domain_ids"></a> [domain\_ids](#output\_domain\_ids) | Domain IDs of the WAF CLB domains. |
| <a name="output_log_post_cls_id"></a> [log\_post\_cls\_id](#output\_log\_post\_cls\_id) | ID of the CLS log post flow resource (null when `enable_cls_log = false`). |
| <a name="output_log_post_cls_flow_id"></a> [log\_post\_cls\_flow\_id](#output\_log\_post\_cls\_flow\_id) | Unique ID for the CLS post flow (null when `enable_cls_log = false`). |
| <a name="output_log_post_cls_log_topic_id"></a> [log\_post\_cls\_log\_topic\_id](#output\_log\_post\_cls\_log\_topic\_id) | CLS log topic ID (null when `enable_cls_log = false`). |
| <a name="output_log_post_cls_logset_id"></a> [log\_post\_cls\_logset\_id](#output\_log\_post\_cls\_logset\_id) | CLS logset ID (null when `enable_cls_log = false`). |
| <a name="output_log_post_cls_status"></a> [log\_post\_cls\_status](#output\_log\_post\_cls\_status) | CLS post flow status: `0` off, `1` on (null when `enable_cls_log = false`). |
| <a name="output_attack_log_post_config_id"></a> [attack\_log\_post\_config\_id](#output\_attack\_log\_post\_config\_id) | ID of the attack-log post config resource. |

---

## Configuration Examples

### `terraform.tfvars`

```hcl
# WAF instance base configuration
goods_category  = "enterprise_clb"
instance_name   = "my-waf-instance"
time_span       = 12
time_unit       = "m"
auto_renew_flag = 1
elastic_mode    = 1
qps_limit       = 100000
api_security    = 1
bot_management  = 1

# Domain configuration
domain_configs = [
  {
    domain      = "example.com"
    region      = "ap-guangzhou"
    is_cdn      = 0
    status      = 1
    engine      = 20
    flow_mode   = 1
    alb_type    = "clb"
    bot_status  = 1
    api_safe_status = 1
    ip_headers  = []
    load_balancer_set = [
      {
        load_balancer_id   = "lb-123456"
        load_balancer_name = "my-loadbalancer"
        listener_id        = "lbl-123456"
        listener_name      = "http-listener"
        vport              = 80
        protocol           = "http"
        region             = "ap-guangzhou"
        zone               = "ap-guangzhou-1"
        vip                = "192.168.1.1"
        load_balancer_type = "OPEN"
      }
    ]
  }
]

# CLS log delivery (must enable enable_cls_log)
enable_cls_log  = true
cls_region      = "ap-shanghai"
log_topic_name  = "waf-access-logs"
log_type        = 1
logset_name     = "waf-logs"

# Attack log configuration
attack_log_post = 1
```

### Production environment configuration

```hcl
# Production WAF configuration
goods_category  = "ultimate_clb"  # Ultimate edition
instance_name   = "prod-waf-instance"
time_span       = 12
time_unit       = "m"
auto_renew_flag = 1
elastic_mode    = 1
qps_limit       = 500000
api_security    = 1
bot_management  = 1

# Production domain configuration
domain_configs = [
  {
    domain      = "api.example.com"
    region      = "ap-shanghai"
    is_cdn      = 0
    status      = 1
    engine      = 20
    flow_mode   = 1
    alb_type    = "clb"
    bot_status  = 1
    api_safe_status = 1
    load_balancer_set = [
      {
        load_balancer_id   = "lb-prod-001"
        load_balancer_name = "prod-api-lb"
        listener_id        = "lbl-prod-http"
        listener_name      = "prod-http"
        vport              = 80
        protocol           = "http"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      },
      {
        load_balancer_id   = "lb-prod-002"
        load_balancer_name = "prod-api-https-lb"
        listener_id        = "lbl-prod-https"
        listener_name      = "prod-https"
        vport              = 443
        protocol           = "https"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      }
    ]
  }
]

# Production log configuration
enable_cls_log  = true
cls_region      = "ap-shanghai"
log_topic_name  = "prod-waf-logs"
log_type        = 1
logset_name     = "prod-security-logs"
attack_log_post = 1
```

### Multi-domain configuration

```hcl
# Multi-domain WAF configuration
goods_category  = "enterprise_clb"
instance_name   = "multi-domain-waf"

# Multiple domains
domain_configs = [
  # Primary domain
  {
    domain      = "example.com"
    region      = "ap-beijing"
    flow_mode   = 1
    load_balancer_set = [
      {
        load_balancer_id   = "lb-main"
        load_balancer_name = "main-lb"
        listener_id        = "lbl-main"
        listener_name      = "main-listener"
        vport              = 80
        protocol           = "http"
        region             = "ap-beijing"
        zone               = "ap-beijing-1"
      }
    ]
  },
  # API subdomain
  {
    domain      = "api.example.com"
    region      = "ap-beijing"
    flow_mode   = 1
    bot_status  = 1
    api_safe_status = 1
    load_balancer_set = [
      {
        load_balancer_id   = "lb-api"
        load_balancer_name = "api-lb"
        listener_id        = "lbl-api"
        listener_name      = "api-listener"
        vport              = 8080
        protocol           = "http"
        region             = "ap-beijing"
        zone               = "ap-beijing-1"
      }
    ]
  }
]
```

### Minimal configuration

```hcl
# Minimal WAF configuration
goods_category = "premium_clb"

# Single domain only
domain_configs = [
  {
    domain = "test.example.com"
    region = "ap-guangzhou"
    load_balancer_set = [
      {
        load_balancer_id   = "lb-test"
        load_balancer_name = "test-lb"
        listener_id        = "lbl-test"
        listener_name      = "test-listener"
        vport              = 80
        protocol           = "http"
        region             = "ap-guangzhou"
        zone               = "ap-guangzhou-1"
      }
    ]
  }
]
```

---

## Usage Examples

### Example 1: E-commerce website protection

```hcl
# E-commerce WAF configuration
goods_category  = "ultimate_clb"  # highest protection
instance_name   = "ecommerce-waf"
time_span       = 12
auto_renew_flag = 1
elastic_mode    = 1
qps_limit       = 1000000  # high concurrency
api_security    = 1
bot_management  = 1

# E-commerce domain configuration
domain_configs = [
  {
    domain      = "shop.example.com"
    region      = "ap-shanghai"
    flow_mode   = 1  # cleaning mode
    bot_status  = 1  # enable Bot protection
    api_safe_status = 1  # enable API security
    load_balancer_set = [
      {
        load_balancer_id   = "lb-ecom-http"
        load_balancer_name = "ecommerce-http"
        listener_id        = "lbl-http"
        listener_name      = "http-port"
        vport              = 80
        protocol           = "http"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      },
      {
        load_balancer_id   = "lb-ecom-https"
        load_balancer_name = "ecommerce-https"
        listener_id        = "lbl-https"
        listener_name      = "https-port"
        vport              = 443
        protocol           = "https"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      }
    ]
  }
]

# Full log monitoring
enable_cls_log  = true
cls_region      = "ap-shanghai"
log_topic_name  = "ecommerce-waf-logs"
log_type        = 1
logset_name     = "ecommerce-security"
attack_log_post = 1
```

### Example 2: API gateway protection

```hcl
# API gateway WAF configuration
goods_category  = "enterprise_clb"
instance_name   = "api-gateway-waf"

# API gateway domain configuration
domain_configs = [
  {
    domain      = "api.company.com"
    region      = "ap-beijing"
    alb_type    = "apisix"  # API gateway type
    flow_mode   = 1
    bot_status  = 1
    api_safe_status = 1  # protect APIs
    load_balancer_set = [
      {
        load_balancer_id   = "lb-api-gw"
        load_balancer_name = "api-gateway"
        listener_id        = "lbl-api"
        listener_name      = "api-listener"
        vport              = 8000
        protocol           = "http"
        region             = "ap-beijing"
        zone               = "ap-beijing-3"
      }
    ]
  }
]

# Detailed API access logs
enable_cls_log  = true
cls_region      = "ap-beijing"
log_topic_name  = "api-gateway-logs"
log_type        = 1
logset_name     = "api-security"
attack_log_post = 1
```

### Example 3: CDN-accelerated website protection

```hcl
# CDN website WAF configuration
goods_category = "premium_clb"

# CDN domain configuration
domain_configs = [
  {
    domain      = "cdn.example.com"
    region      = "ap-guangzhou"
    is_cdn      = 1  # CDN enabled
    flow_mode   = 0  # mirroring mode suits CDN
    load_balancer_set = [
      {
        load_balancer_id   = "lb-cdn"
        load_balancer_name = "cdn-lb"
        listener_id        = "lbl-cdn"
        listener_name      = "cdn-listener"
        vport              = 80
        protocol           = "http"
        region             = "ap-guangzhou"
        zone               = "ap-guangzhou-1"
      }
    ]
  }
]

# Basic log configuration
enable_cls_log  = true
cls_region      = "ap-guangzhou"
log_type        = 1
```

### Example 4: Finance application with high security

```hcl
# Finance application WAF configuration
goods_category  = "ultimate_clb"  # Ultimate edition
instance_name   = "finance-waf"
time_span       = 24  # 2-year subscription
time_unit       = "m"
auto_renew_flag = 1

# Strict finance domain protection
domain_configs = [
  {
    domain      = "bank.example.com"
    region      = "ap-shanghai"
    flow_mode   = 1  # cleaning mode
    bot_status  = 1  # Bot protection
    api_safe_status = 1  # API security
    load_balancer_set = [
      {
        load_balancer_id   = "lb-finance-https"
        load_balancer_name = "finance-https"
        listener_id        = "lbl-https"
        listener_name      = "https-port"
        vport              = 443
        protocol           = "https"
        region             = "ap-shanghai"
        zone               = "ap-shanghai-2"
      }
    ]
  }
]

# Full audit logs
enable_cls_log      = true
cls_region          = "ap-shanghai"
log_topic_name      = "finance-waf-audit"
log_type            = 2  # attack log
logset_name         = "finance-security"
attack_log_post     = 1
```

---

## Configuration Notes

### WAF edition comparison

| Edition | Code | Protection | Use case | Price |
|---------|------|------------|----------|-------|
| **Premium** | premium_clb | Basic web protection | Small sites, test env | Low |
| **Enterprise** | enterprise_clb | Enhanced + Bot management | Medium business, production | Medium |
| **Ultimate** | ultimate_clb | Full + API security | Large business, finance | High |

### Traffic mode

#### Cleaning mode (`flow_mode = 1`)
- **How it works**: traffic is cleaned by WAF before being forwarded to the backend.
- **Advantage**: real-time protection; malicious traffic is blocked.
- **Use case**: production, high-security scenarios.
- **Latency**: slightly increased.

#### Mirroring mode (`flow_mode = 0`)
- **How it works**: traffic is mirrored to WAF for analysis without affecting normal traffic.
- **Advantage**: zero latency, no impact on performance.
- **Use case**: monitoring/analysis, CDN acceleration.
- **Protection**: detect only, no blocking.

### Elastic billing mode

- **Enabled (`elastic_mode = 1`)**: billed by actual QPS, supports dynamic scaling.
- **Disabled (`elastic_mode = 0`)**: fixed QPS quota; traffic above it is limited.
- **QPS limit**: min `10000`, set per traffic peak.
- **Cost optimization**: choose a suitable QPS limit per traffic pattern.

### Security features

#### API security (`api_security`)
- **Feature**: specifically protect API endpoints.
- **Use case**: RESTful APIs, microservice architecture.
- **Protection**: API injection, unauthorized access, parameter pollution, etc.

#### Bot management (`bot_management`)
- **Feature**: intelligently identify malicious bot traffic.
- **Protection**: crawlers, scalping, credential stuffing, CC attacks, etc.
- **Strategy**: behavior analysis, fingerprinting, challenge-response.

### Load balancer types

| Type | Code | Description | Use case |
|------|------|-------------|----------|
| **CLB** | clb | Traditional load balancer | Regular web apps |
| **APISIX** | apisix | API gateway | Microservice architecture |
| **TSEGW** | tsegw | Traffic engine gateway | High-performance scenarios |

### CLS log delivery

#### Log type
- **Access log (`log_type = 1`)**: records all request access info.
- **Attack log (`log_type = 2`)**: records only blocked attack requests.

#### CLS configuration tips
- **Region**: choose the region closest to your business to reduce latency.
- **Topic naming**: name by business function for easy retrieval.
- **Logset management**: divide logsets by environment or project.

> **Note**: To actually deliver logs, set `enable_cls_log = true`. The CLS flow outputs (`log_post_cls_*`) are `null` when it is `false`.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Edition selection**
   - Confirm the WAF edition meets business needs and budget.
   - Ultimate provides the most comprehensive protection.
   - Premium fits testing and small apps.

2. **Domain configuration**
   - Ensure the domain is ICP-filed and resolves correctly.
   - Confirm load-balancer config is correct.
   - Check region/availability-zone matching.

3. **Traffic mode**
   - Use cleaning mode in production.
   - Use mirroring mode for CDN scenarios.
   - Confirm the mode fits business needs.

4. **Elastic billing**
   - Elastic mode scales but costs more.
   - Fixed mode is predictable but may throttle.
   - Choose a mode per traffic characteristics.

5. **Security features**
   - API security adds resource consumption.
   - Bot management requires extra authorization.
   - Confirm relevant features are purchased.

6. **Log configuration**
   - CLS incurs additional cost.
   - Attack-log delivery needs extra config.
   - Confirm CLS region availability and set `enable_cls_log = true`.

7. **Permission verification**
   - Confirm sufficient WAF operation permissions.
   - Check load-balancer access permissions.
   - Verify CLS log service permissions.

8. **Network connectivity**
   - Confirm WAF region matches the business region.
   - Check load-balancer network config.
   - Verify domain resolution.

9. **Performance**
   - Set a reasonable QPS limit to avoid over-provisioning.
   - Consider peak traffic.
   - Monitor WAF performance metrics.

10. **Compliance**
    - Ensure configuration meets security/compliance standards.
    - Retain enough logs for auditing.
    - Follow data-security regulations.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=PermissionDenied
Message=Insufficient permissions
```

**Cause**: The current account lacks sufficient permissions.
**Solution**:
- Check WAF related permissions.
- Request `QcloudWAFFullAccess`.
- Verify load-balancer permissions.

#### Error 2: Region not supported

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region not available
```

**Cause**: The selected region does not support WAF.
**Solution**:
- Check region availability.
- Choose a supported region.
- Contact Tencent Cloud support.

#### Error 3: Invalid domain configuration

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid domain configuration
```

**Cause**: Wrong domain configuration parameter.
**Solution**:
- Check the `domain_configs` format.
- Confirm load-balancer info is correct.
- Verify region matching.

#### Error 4: QPS limit too low

```
Error: [TencentCloudSDKError] Code=LimitExceeded
Message=QPS limit too low
```

**Cause**: The QPS limit is set too low.
**Solution**:
- Increase the `qps_limit` value.
- Confirm elastic mode is enabled.
- Contact Tencent Cloud to adjust the quota.

#### Error 5: Load balancer binding failed

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=LoadBalancer not found
```

**Cause**: The load balancer does not exist or permissions are insufficient.
**Solution**:
- Check the load balancer ID is correct.
- Confirm load-balancer access permissions.
- Verify the load balancer status is normal.

#### Error 6: CLS configuration error

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=CLS configuration error
```

**Cause**: Wrong CLS log configuration.
**Solution**:
- Check CLS region availability.
- Confirm the log topic and logset exist.
- Verify CLS service permissions and `enable_cls_log = true`.

#### Error 7: Feature not purchased

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Feature not purchased
```

**Cause**: An unpurchased feature is used.
**Solution**:
- Confirm the corresponding WAF edition is purchased.
- Check whether API security or Bot management is enabled.
- Contact Tencent Cloud to purchase the required feature.

## License

See [LICENSE](../../../../LICENSE) for full details.