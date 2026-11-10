# EdgeOne SSL Certificate (teo-cert) Terraform Module

This module configures the **SSL certificate** for an EdgeOne acceleration domain (`tencentcloud_teo_certificate_config`). It supports three certificate modes: disabling the certificate, using the EdgeOne free certificate, or binding a specific SSL certificate by `CertId`.

Key capabilities:

- **Certificate configuration** — applies an SSL certificate config to a given EdgeOne zone + host.
- **Modes** — `disable` (do not configure), `eofreecert` (EdgeOne free certificate), `sslcert` (bind a specific SSL certificate by `CertId`).
- **Conditional creation** — the `tencentcloud_teo_certificate_config.cert` resource is only created when `ssl_cert` is not `null`. When `ssl_cert` is omitted, no certificate config is managed.
- **Custom timeouts** — `create` / `update` timeouts configurable (default `20m`).

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
| `tencentcloud_teo_certificate_config.cert` | resource (count = 1 when `ssl_cert` is set) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_edgeone_zone_id"></a> [edgeone\_zone\_id](#input\_edgeone\_zone\_id) | `string` | no | `""` | ID of the EdgeOne zone. |
| <a name="input_ssl_cert"></a> [ssl\_cert](#input\_ssl\_cert) | `object` | no | `null` | EdgeOne SSL certificate config. When `null`, no certificate config resource is created. |

### `ssl_cert` object

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `host` | `string` | yes | Acceleration domain name whose certificate configuration is to be modified. |
| `mode` | `string` | yes | Certificate configuration mode: `disable` (do not configure), `eofreecert` (EdgeOne free certificate), `sslcert` (configure an SSL certificate by `CertId`). Defaults to `disable` when not filled. |
| `server_cert_info` | `list(object)` | no | SSL certificate configuration; takes effect only when `mode = "sslcert"`. Only `cert_id` is required — you can obtain it from the SSL certificate list. Each element: |
| `timeouts` | `object` | no | Timeout settings. |

#### `server_cert_info` element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `cert_id` | `string` | yes | – | ID of the server certificate. |
| `alias` | `string` | no | – | Alias of the certificate. |
| `type` | `string` | no | – | Type of the certificate: `default` (default certificate), `upload` (specified certificate), `managed` (Tencent Cloud-managed certificate). |
| `common_name` | `string` | yes | – | Domain name of the certificate. |
| `deploy_time` | `string` | no | – | Time when the certificate is deployed. |
| `expire_time` | `string` | no | – | Time when the certificate expires. |
| `sign_algo` | `string` | no | – | Signature algorithm. |

#### `timeouts` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `create` | `string` | no | `"20m"` | Timeout for creating the certificate config. |
| `update` | `string` | no | `"20m"` | Timeout for updating the certificate config. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_id"></a> [cert\_id](#output\_cert\_id) | ID of the certificate config (null when `ssl_cert` is not set). |

## Usage

### Bind a specific SSL certificate (mode = `sslcert`)

```hcl
module "teo_cert" {
  source = "./modules/teo-cert"

  edgeone_zone_id = "zone-xxxxxxxx"

  ssl_cert = {
    host = "www.example.com"
    mode = "sslcert"
    server_cert_info = [
      {
        cert_id     = "abxG1h2k"
        common_name = "www.example.com"
        type        = "managed"
      }
    ]
  }
}
```

### Use EdgeOne free certificate (mode = `eofreecert`)

```hcl
module "teo_cert" {
  source = "./modules/teo-cert"

  edgeone_zone_id = "zone-xxxxxxxx"

  ssl_cert = {
    host = "www.example.com"
    mode = "eofreecert"
  }
}
```

### Disable certificate (mode = `disable`) / no certificate managed

```hcl
module "teo_cert" {
  source = "./modules/teo-cert"

  edgeone_zone_id = "zone-xxxxxxxx"

  # Omit ssl_cert (or set mode = "disable") to skip certificate config creation.
  ssl_cert = {
    host = "www.example.com"
    mode = "disable"
  }
}
```

> **Notes**:
> - `server_cert_info` and its fields (except `cert_id` / `common_name`) are only relevant when `mode = "sslcert"`. In that mode only `cert_id` is strictly required — the `CertId` can be obtained from the SSL certificate list.
> - The `tencentcloud_teo_certificate_config.cert` resource is created only when `ssl_cert` is not `null`; otherwise `cert_id` output returns `null`.
