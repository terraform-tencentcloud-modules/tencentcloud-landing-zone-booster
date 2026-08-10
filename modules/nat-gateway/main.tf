locals {
  nat_gateway_id = try(var.create_nat_gateway, true) ? concat(tencentcloud_nat_gateway.nat.*.id, [""])[0] : var.nat_gateway_id
  vpc_instance   = try(data.tencentcloud_vpc_instances.vpc.instance_list.0, {})
  vpc_id         = try(var.vpc_id, "") != "" ? var.vpc_id : try(local.vpc_instance.vpc_id, null)

  default_route_table_id = try([
    for rt in data.tencentcloud_vpc_route_tables.route_tables.instance_list : rt.route_table_id if rt.is_default
  ][0], "")

  routable_attachments = {
    default = {
      route_table_id   = local.default_route_table_id
      destination_cidr = "0.0.0.0/0"
    }
  }
}

data "tencentcloud_vpc_instances" "vpc" {
  name = var.vpc_instance_name
}

data "tencentcloud_vpc_route_tables" "route_tables" {
  vpc_id           = local.vpc_id
  association_main = true
}

resource "tencentcloud_eip" "eips" {
  count = length(var.nat_eips)
  
  name                       = var.nat_eips[count.index]
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
}

resource "tencentcloud_nat_gateway" "nat" {
  count               = try(var.create_nat_gateway, true) ? 1 : 0
  name                = var.nat_gateway_name
  vpc_id              = local.vpc_id
  bandwidth           = var.nat_product_version == 2 ? null : var.nat_gateway_bandwidth
  max_concurrent      = var.nat_product_version == 2 ? null : var.nat_gateway_concurrent
  assigned_eip_set    = length(var.nat_public_ips) > 0 ? var.nat_public_ips : try(tencentcloud_eip.eips.*.public_ip, null)
  nat_product_version = var.nat_product_version
  tags                = var.tags
}

resource "tencentcloud_route_table_entry" "route_entry" {
  for_each = local.routable_attachments

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr
  next_type              = "NAT"
  next_hub               = local.nat_gateway_id
  lifecycle {
    ignore_changes = [
      disabled // we do not control this toggle here because it will auto managed by other products such as CFW
    ]
  }
}

resource "tencentcloud_nat_gateway_flow_monitor" "nat_flow_monitor" {
  gateway_id = local.nat_gateway_id
  enable     = var.enable_flow_monitor
}