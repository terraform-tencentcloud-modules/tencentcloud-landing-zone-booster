locals {
  identity_provider_id = try(tencentcloud_identity_center_external_saml_identity_provider.identity_provider[0].id, null)
}

resource "tencentcloud_identity_center_external_saml_identity_provider" "identity_provider" {
  count      = var.create ? 1 : 0
  zone_id    = var.zone_id
  sso_status = var.sso_status

  entity_id                 = var.entity_id
  login_url                 = var.login_url
  x509_certificate          = var.x509_certificate
  encoded_metadata_document = var.encoded_metadata_document
}