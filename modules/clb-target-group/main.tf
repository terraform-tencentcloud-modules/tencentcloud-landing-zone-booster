# create target group
resource "tencentcloud_clb_target_group" "this" {
  vpc_id            = var.vpc_id
  target_group_name = var.target_group_name
  type              = var.target_group_type
  protocol          = var.target_group_protocol
  port              = var.target_group_port
}

# bind instance
resource "tencentcloud_clb_target_group_instance_attachment" "this" {
  for_each = { for idx, inst in var.target_instances : idx => inst }

  target_group_id = tencentcloud_clb_target_group.this.id
  port            = each.value.port
  bind_ip         = each.value.bind_ip
  weight          = each.value.weight
}