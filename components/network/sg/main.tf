locals {
  security_group_ids = { for sg in var.security_groups : sg.name => tencentcloud_security_group.sg[sg.name].id }
}

resource "tencentcloud_security_group" "sg" {
  for_each = {
    for sg in var.security_groups : sg.name => sg
  }

  project_id  = each.value.project_id
  name        = each.value.name
  description = each.value.description
  tags        = each.value.tags
}

resource "tencentcloud_security_group_rule_set" "rules" {
  for_each = {
    for sg in var.security_groups : sg.name => sg
  }

  security_group_id = local.security_group_ids[each.key]

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      action                 = ingress.value.action
      cidr_block             = ingress.value.cidr_block
      ipv6_cidr_block        = ingress.value.ipv6_cidr_block
      protocol               = ingress.value.protocol
      port                   = ingress.value.port
      source_security_id     = ingress.value.source_security_id
      address_template_id    = ingress.value.address_template_id
      address_template_group = ingress.value.address_template_group
      service_template_id    = ingress.value.service_template_id
      service_template_group = ingress.value.service_template_group
      description            = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      action                 = egress.value.action
      cidr_block             = egress.value.cidr_block
      ipv6_cidr_block        = egress.value.ipv6_cidr_block
      protocol               = egress.value.protocol
      port                   = egress.value.port
      source_security_id     = egress.value.source_security_id
      address_template_id    = egress.value.address_template_id
      address_template_group = egress.value.address_template_group
      service_template_id    = egress.value.service_template_id
      service_template_group = egress.value.service_template_group
      description            = egress.value.description
    }
  }
}