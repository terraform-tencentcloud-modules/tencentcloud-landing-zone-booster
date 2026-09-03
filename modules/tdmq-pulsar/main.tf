data "tencentcloud_availability_zones_by_product" "this" {
  include_unavailable = true
  product             = var.zone_query_product
}

locals {
  zone_map = {
    for zone in data.tencentcloud_availability_zones_by_product.this.zones : zone.name => zone.id
  }
}

################################################################################
# TDMQ for Pulsar Professional Cluster
# (replaces the deprecated tencentcloud_tdmq_instance)
################################################################################
resource "tencentcloud_tdmq_professional_cluster" "this" {
  cluster_name     = var.cluster.cluster_name
  zone_ids         = [for zone in var.cluster.zone_names : local.zone_map[zone]]
  product_name     = var.cluster.product_name
  instance_version = var.cluster.instance_version
  storage_size     = var.cluster.storage_size
  auto_renew_flag  = var.cluster.auto_renew_flag
  time_span        = var.cluster.time_span
  auto_voucher     = var.cluster.auto_voucher
  tags             = var.cluster.tags

  dynamic "vpc" {
    for_each = var.cluster.vpc_id != null && var.cluster.subnet_id != null ? [1] : []
    content {
      vpc_id    = var.cluster.vpc_id
      subnet_id = var.cluster.subnet_id
    }
  }
}

################################################################################
# Namespaces
################################################################################
resource "tencentcloud_tdmq_namespace" "this" {
  for_each = { for ns in var.namespaces : ns.environ_name => ns }

  environ_name = each.value.environ_name
  msg_ttl      = each.value.msg_ttl
  cluster_id   = tencentcloud_tdmq_professional_cluster.this.id
  remark       = each.value.remark

  dynamic "retention_policy" {
    for_each = each.value.retention_policy != null ? [each.value.retention_policy] : []
    content {
      time_in_minutes = retention_policy.value.time_in_minutes
      size_in_mb      = retention_policy.value.size_in_mb
    }
  }

  dynamic "tags" {
    for_each = each.value.tags
    content {
      tag_key   = tags.value.tag_key
      tag_value = tags.value.tag_value
    }
  }
}

################################################################################
# Roles
################################################################################
resource "tencentcloud_tdmq_role" "this" {
  for_each = { for r in var.roles : r.role_name => r }

  role_name  = each.value.role_name
  cluster_id = tencentcloud_tdmq_professional_cluster.this.id
  remark     = each.value.remark
}

################################################################################
# Topics
################################################################################
resource "tencentcloud_tdmq_topic" "this" {
  for_each = { for t in var.topics : "${t.environ_id}/${t.topic_name}" => t }

  environ_id        = each.value.environ_id
  topic_name        = each.value.topic_name
  partitions        = each.value.partitions
  pulsar_topic_type = each.value.pulsar_topic_type
  cluster_id        = tencentcloud_tdmq_professional_cluster.this.id
  remark            = each.value.remark

  dynamic "tags" {
    for_each = each.value.tags
    content {
      tag_key   = tags.value.tag_key
      tag_value = tags.value.tag_value
    }
  }

  depends_on = [tencentcloud_tdmq_namespace.this]
}

################################################################################
# Subscriptions
################################################################################
resource "tencentcloud_tdmq_subscription" "this" {
  for_each = { for s in var.subscriptions : "${s.environment_id}/${s.topic_name}/${s.subscription_name}" => s }

  cluster_id               = tencentcloud_tdmq_professional_cluster.this.id
  environment_id           = each.value.environment_id
  topic_name               = each.value.topic_name
  subscription_name        = each.value.subscription_name
  remark                   = each.value.remark
  auto_create_policy_topic = each.value.auto_create_policy_topic
  auto_delete_policy_topic = each.value.auto_delete_policy_topic

  depends_on = [
    tencentcloud_tdmq_namespace.this,
    tencentcloud_tdmq_topic.this,
  ]
}

################################################################################
# Namespace-Role Attachments
################################################################################
resource "tencentcloud_tdmq_namespace_role_attachment" "this" {
  for_each = { for a in var.namespace_role_attachments : "${a.environ_id}/${a.role_name}" => a }

  environ_id  = each.value.environ_id
  role_name   = each.value.role_name
  permissions = each.value.permissions
  cluster_id  = tencentcloud_tdmq_professional_cluster.this.id

  depends_on = [
    tencentcloud_tdmq_namespace.this,
    tencentcloud_tdmq_role.this,
  ]
}
