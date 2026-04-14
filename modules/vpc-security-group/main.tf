resource "tencentcloud_security_group" "sg" {
  project_id  = var.project_id
  name        = var.name
  description = var.description
  tags        = var.tags
}

resource "tencentcloud_security_group_rule_set" "rules" {
  security_group_id = tencentcloud_security_group.sg.id

  dynamic "ingress" {
    for_each = var.ingress_rules
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
    for_each = var.egress_rules
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