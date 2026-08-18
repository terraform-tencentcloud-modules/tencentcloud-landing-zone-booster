resource "tencentcloud_ccn_attachment_v2" "attachment" {
  ccn_id          = var.ccn_id
  ccn_uin         = var.ccn_uin
  
  instance_id     = var.instance_id
  instance_type   = var.instance_type
  instance_region = var.instance_region
  description     = var.description
}