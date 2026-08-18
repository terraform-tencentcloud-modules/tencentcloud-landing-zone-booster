resource "tencentcloud_vpc_acl_attachment" "attachment" {
  acl_id    = var.network_acl_id
  subnet_id = var.vpc_subnet_id
}