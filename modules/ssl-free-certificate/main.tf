resource "tencentcloud_ssl_free_certificate" "free" {
  project_id         = var.project_id
  alias              = var.alias
  dv_auth_method     = var.dv_auth_method
  domain             = var.domain
  package_type       = var.package_type
  contact_email      = var.contact_email
  contact_phone      = var.contact_phone
  validity_period    = var.validity_period
  csr_encrypt_algo   = var.csr_encrypt_algo
  csr_key_parameter  = var.csr_key_parameter
  csr_key_password   = var.csr_key_password
  old_certificate_id = var.old_certificate_id
}