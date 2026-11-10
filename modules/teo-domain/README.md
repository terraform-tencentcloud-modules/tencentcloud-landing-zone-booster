# EdgeOne Acceleration Domain (teo-domain) Terraform Module

This module creates an **EdgeOne acceleration domain** (`tencentcloud_teo_acceleration_domain`) under a given EdgeOne zone, including its origin (back-to-source) configuration.

Key capabilities:

- **Acceleration domain** — register an accelerated domain name within an EdgeOne zone, with configurable HTTP/HTTPS origin ports and IPv6 status.
- **Origin configuration** — one or more origin entries (`origin_info`) supporting various origin types: `IP_DOMAIN`, `COS`, `ORIGIN_GROUP`, `AWS_S3`, `SPACE`.
- **Conditional creation** — the `tencentcloud_teo_acceleration_domain.domain` resource is only created when `acc_domain` is not `null`. When `acc_domain` is omitted, no acceleration domain is managed.
- **Field constraint logic** (handled in `main.tf`):
  - `host_header` is only applied when `origin_type = "IP_DOMAIN"`; otherwise it is `null` (for `COS`/`AWS_S3` the header follows the origin domain name).
  - `private_access` is only applied when `origin_type = "COS"` or `"AWS_S3"`; otherwise it is `null`.
  - `private_parameters` is only rendered when `private_access = "on"`.
- **Lifecycle** — `ignore_changes` is set on `origin_info[0].private_parameters` to avoid drift on the private-access secret values.

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
| `tencentcloud_teo_acceleration_domain.domain` | resource (count = 1 when `acc_domain` is set) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_edgeone_zone_id"></a> [edgeone\_zone\_id](#input\_edgeone\_zone\_id) | `string` | no | `""` | ID of the EdgeOne zone. |
| <a name="input_acc_domain"></a> [acc\_domain](#input\_acc\_domain) | `object` | no | `null` | Acceleration domain config. When `null`, no acceleration domain resource is created. |

### `acc_domain` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `domain_name` | `string` | yes | – | Accelerated domain name. |
| `http_origin_port` | `number` | no | `80` | HTTP back-to-origin port. |
| `https_origin_port` | `number` | no | `443` | HTTPS back-to-origin port. |
| `ipv6_status` | `string` | no | `"follow"` | IPv6 status: `follow` (follow the site IPv6 config), `on`, `off`. |
| `origin_protocol` | `string` | yes | – | Origin-pull protocol: `FOLLOW` (protocol follow), `HTTP`, `HTTPS`. |
| `origin_info` | `list(object)` | yes | – | The origin info list. See element structure below. |

#### `origin_info` element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `origin_type` | `string` | yes | – | Origin type: `IP_DOMAIN` (IPv4/IPv6 address or domain name), `COS` (COS bucket address), `ORIGIN_GROUP` (origin group), `AWS_S3` (AWS S3 bucket address), `SPACE` (EdgeOne Shield Space). |
| `origin` | `string` | yes | – | The origin address. |
| `host_header` | `string` | no | – | Custom back-to-origin HOST header. **Only valid when `origin_type = "IP_DOMAIN"`** (when `COS`/`AWS_S3`, the header follows the origin domain name). |
| `backup_origin` | `string` | no | – | ID of the secondary origin group (valid when `origin_type = "ORIGIN_GROUP"`). |
| `private_access` | `string` | no | – | Whether to authenticate access to the private object-storage origin (**valid when `origin_type = "COS"`/`"AWS_S3"`**): `on` (enable private authentication), `off` (disable, default). |
| `private_parameters` | `list(object)` | no | – | Private authentication parameters. **Valid only when `private_access = "on"`**. Each element: |

##### `private_parameters` element

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | `string` | yes | Parameter name: `AccessKeyId` (Access Key ID) or `SecretAccessKey` (Secret Access Key). |
| `value` | `string` | yes | Parameter value. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the acceleration domain (null when `acc_domain` is not set). |
| <a name="output_cname"></a> [cname](#output\_cname) | CNAME address of the acceleration domain (null when `acc_domain` is not set). |

## Usage

### IP/Domain origin

```hcl
module "teo_domain" {
  source = "./modules/teo-domain"

  edgeone_zone_id = "zone-xxxxxxxx"

  acc_domain = {
    domain_name       = "www.example.com"
    http_origin_port  = 80
    https_origin_port = 443
    ipv6_status       = "follow"
    origin_protocol   = "FOLLOW"
    origin_info = [
      {
        origin_type = "IP_DOMAIN"
        origin      = "1.2.3.4"
        host_header = "origin.internal"
      }
    ]
  }
}
```

### COS private-origin with authentication

```hcl
module "teo_domain" {
  source = "./modules/teo-domain"

  edgeone_zone_id = "zone-xxxxxxxx"

  acc_domain = {
    domain_name     = "static.example.com"
    origin_protocol = "HTTPS"
    origin_info = [
      {
        origin_type      = "COS"
        origin           = "my-bucket-1234567890.cos.ap-guangzhou.myqcloud.com"
        private_access  = "on"
        private_parameters = [
          { name = "AccessKeyId",     value = "AKIDxxxxxxxx" },
          { name = "SecretAccessKey", value = "xxxxxxxxxxxx" }
        ]
      }
    ]
  }
}
```

> **Notes**:
> - `host_header` is ignored unless `origin_type = "IP_DOMAIN"`.
> - `private_access` and `private_parameters` are ignored unless `origin_type` is `COS` or `AWS_S3`.
> - `private_parameters` under `origin_info[0]` are excluded from drift detection (`ignore_changes`), so changes to the secret values in the provider state will be ignored.
> - The `tencentcloud_teo_acceleration_domain.domain` resource is created only when `acc_domain` is not `null`; otherwise both `id` and `cname` outputs return `null`.
