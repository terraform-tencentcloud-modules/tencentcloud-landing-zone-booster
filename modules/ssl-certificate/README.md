# TencentCloud SSL Module for Terraform

## terraform-tencentcloud-ssl-certificate

A terraform module used to create a TencentCloud SSL Certificate (`tencentcloud_ssl_certificate`).

The following resources are included.

* [SSL Certificate](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ssl_certificate)

## Usage

If SSL certificate type is `CA`

```hcl
variable "ca" {
  # Content of the CA certificate (no leading/trailing newline).
  default = file("${path.module}/ca.pem")
}

resource "tencentcloud_ssl_certificate" "ca" {
  name = "ssl-ca"
  type = "CA"
  cert = var.ca
}
```

If SSL certificate type is `SVR`

```hcl
variable "cert" {
  # Content of the server certificate (no leading/trailing newline).
  default = file("${path.module}/server.pem")
}

variable "key" {
  # Private key of the server certificate (no leading/trailing newline).
  default = file("${path.module}/server.key")
}

resource "tencentcloud_ssl_certificate" "svr" {
  name = "ssl-svr"
  type = "SVR"
  cert = var.cert
  key  = var.key
}
```

## Conditional Creation

This module always creates the certificate. To use an existing certificate, reference it via a `data` source or `tencentcloud_ssl_certificates` instead of this module.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | Project ID of the SSL certificate. Default is `0`. | number | 0 | no |
| name | Name of the SSL certificate. | string | "" | no |
| type | Type of the SSL certificate. Valid values: `CA` and `SVR`. | string | n/a | yes |
| cert | Content of the SSL certificate. No leading/trailing newline. | string | n/a | yes |
| key | Key of the SSL certificate, required when `type` is `SVR`. No leading/trailing newline. | string | null | no |
| tags | Tags of the SSL certificate. | map(string) | null | no |

## Outputs

| Name                          | Description                              |
|-------------------------------|------------------------------------------|
| id                            | The id of ssl certificate.               |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ssl-certificate)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
