# TencentCloud SSL Free Certificate Module for Terraform

## terraform-tencentcloud-ssl-free-certificate

A terraform module used to apply for a TencentCloud free SSL certificate (`tencentcloud_ssl_free_certificate`).

The following resources are included.

* [SSL Free Certificate](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ssl_free_certificate)

## Usage

```hcl
module "ssl_free_certificate" {
  source = "terraform-tencentcloud-modules/ssl-free-certificate/tencentcloud"

  domain          = "example.com"
  dv_auth_method  = "DNS_AUTO" # DNS_AUTO, DNS, FILE
  package_type    = "2"        # only "2" (TrustAsia TLS RSA CA) is supported
  validity_period = "3"        # only "3" months is supported
  csr_encrypt_algo = "RSA"     # only "RSA" is supported
  csr_key_parameter = "2048"   # only "2048" is supported

  alias          = "my-free-cert"
  contact_email  = "admin@example.com"
  contact_phone  = "13800000000"
  project_id     = 0
  # old_certificate_id = "abc-123" # set when re-applying for an existing certificate
}
```

## Conditional Creation

The free certificate is always created by this module. To reference an existing certificate instead of creating a new one, manage it outside this module.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | ID of the project this certificate belongs to. | number | null | no |
| alias | Alias used as a remark for the certificate. | string | null | no |
| dv_auth_method | DV authorization method. Valid values: `DNS_AUTO` (automatic DNS auth), `DNS` (manual DNS auth), `FILE` (file auth). | string | n/a | yes |
| domain | Domain name to apply the certificate for. | string | n/a | yes |
| package_type | Type of package. Only `2` (TrustAsia TLS RSA CA) is supported. | string | "2" | no |
| contact_email | Email address of the certificate contact. | string | null | no |
| contact_phone | Phone number of the certificate contact. | string | null | no |
| validity_period | Validity period in months. Only `3` months is supported. | string | "3" | no |
| csr_encrypt_algo | CSR encryption algorithm. Only `RSA` is supported. | string | "RSA" | no |
| csr_key_parameter | CSR key parameter. Only `2048` is supported. | string | "2048" | no |
| csr_key_password | CSR key password. | string | null | no |
| old_certificate_id | Old certificate ID, used when re-applying. | string | null | no |

## Outputs

| Name | Description |
|------|-------------|
| certificate_id | The ID of the SSL free certificate. |
| certificate_domain | The domain of the SSL free certificate. |
| certificate_status | The status of the SSL free certificate. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ssl-free-certificate)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
