# terraform-tencentcloud-tco-identity-center-external-saml-identity-provider

Terraform module which creates an external SAML identity provider for the TencentCloud Organization (TCO) Identity Center on TencentCloud.

The following resources are included.

* [Identity Center External SAML Identity Provider](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/identity_center_external_saml_identity_provider)

## Usage

```hcl
variable "zone_id" {
  type    = string
  default = "z-xxxxxxxxxxxxxxxxxxxx"
}

variable "encoded_metadata_document" {
  type    = string
  default = filebase64("${path.module}/saml-metadata.xml")
}

variable "entity_id" {
  type    = string
  default = "https://example-idp.com/saml"
}

variable "login_url" {
  type    = string
  default = "https://example-idp.com/login"
}

variable "x509_certificate" {
  type    = string
  default = file("${path.module}/idp-cert.pem")
}

module "identity_provider" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-external-saml-identity-provider.git"

  zone_id                    = var.zone_id
  sso_status                 = "Enabled"
  encoded_metadata_document = var.encoded_metadata_document
  entity_id                 = var.entity_id
  login_url                 = var.login_url
  x509_certificate          = var.x509_certificate
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Whether to create the external SAML identity provider. | bool | true | no |
| zone_id | The zone ID of the Identity Center. | string | "" | no |
| sso_status | (Optional, String) SSO enabling status. Valid values: Enabled, Disabled (default). | string | "Enabled" | no |
| encoded_metadata_document | IdP metadata document (Base64 encoded). Provided by an IdP that supports the SAML 2.0 protocol. | string | null | no |
| entity_id | IdP identifier. | string | null | no |
| login_url | IdP login URL. | string | null | no |
| x509_certificate | X509 certificate in PEM format. If this parameter is specified, all existing certificates will be replaced. | string | null | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the external SAML identity provider. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-identity-center-external-saml-identity-provider)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
