################################################################################
# Get numeric zone_id for CKafka (zone_id is Int type)
################################################################################
data "tencentcloud_zones" "az" {
  product = var.zone_query_product
}

locals {
  # Build a map of zone name to zone id
  zone_id_map = {
    for zone in data.tencentcloud_zones.az.zone_list :
    zone.zone => zone.zone_id
  }
}

################################################################################
# CKafka Instance
################################################################################
resource "tencentcloud_ckafka_instance" "this" {
  for_each = var.instances

  instance_name            = each.value.instance_name
  zone_id                  = local.zone_id_map[each.value.zone_name]
  multi_zone_flag          = each.value.multi_zone_flag
  zone_ids                 = each.value.multi_zone_flag ? toset([
    for zone in each.value.zone_names : local.zone_id_map[zone]
  ]) : null
  vpc_id                   = each.value.vpc_id
  subnet_id                = each.value.subnet_id
  charge_type              = each.value.charge_type
  period                   = each.value.period
  instance_type            = each.value.instance_type
  specifications_type      = each.value.specifications_type
  upgrade_strategy         = each.value.upgrade_strategy
  kafka_version            = each.value.kafka_version
  disk_type                = each.value.disk_type
  disk_size                = each.value.disk_size
  band_width               = each.value.band_width
  partition                = each.value.partition
  msg_retention_time       = each.value.msg_retention_time
  renew_flag               = each.value.renew_flag
  public_network           = each.value.public_network
  max_message_byte         = each.value.max_message_byte
  elastic_bandwidth_switch = each.value.elastic_bandwidth_switch
  custom_ssl_cert_id       = each.value.custom_ssl_cert_id
  delete_protection_enable = each.value.delete_protection_enable
  tag_set                  = each.value.tag_set

  dynamic "config" {
    for_each = each.value.config == null ? [] : [each.value.config]
    content {
      auto_create_topic_enable   = config.value.auto_create_topic_enable
      default_num_partitions     = config.value.default_num_partitions
      default_replication_factor = config.value.default_replication_factor
    }
  }

  dynamic "dynamic_retention_config" {
    for_each = each.value.dynamic_retention_config == null ? [] : [each.value.dynamic_retention_config]
    content {
      enable                  = dynamic_retention_config.value.enable
      disk_quota_percentage   = dynamic_retention_config.value.disk_quota_percentage
      step_forward_percentage = dynamic_retention_config.value.step_forward_percentage
      bottom_retention        = dynamic_retention_config.value.bottom_retention
    }
  }
}

################################################################################
# CKafka Topic
################################################################################
resource "tencentcloud_ckafka_topic" "this" {
  for_each = var.topics

  instance_id                    = tencentcloud_ckafka_instance.this[each.value.instance_key].id
  topic_name                     = each.value.topic_name
  partition_num                  = each.value.partition_num
  replica_num                    = each.value.replica_num
  enable_white_list              = each.value.enable_white_list
  ip_white_list                  = each.value.ip_white_list
  note                           = each.value.note
  retention                      = each.value.retention
  sync_replica_min_num           = each.value.sync_replica_min_num
  clean_up_policy                = each.value.clean_up_policy
  unclean_leader_election_enable = each.value.unclean_leader_election_enable
  segment                        = each.value.segment

  depends_on = [tencentcloud_ckafka_instance.this]
}

################################################################################
# CKafka Route (access point)
################################################################################
resource "tencentcloud_ckafka_route" "this" {
  for_each = var.routes

  instance_id    = tencentcloud_ckafka_instance.this[each.value.instance_key].id
  vip_type       = each.value.vip_type
  vpc_id         = each.value.vpc_id
  subnet_id      = each.value.subnet_id
  access_type    = each.value.access_type
  auth_flag      = each.value.auth_flag
  caller_appid   = each.value.caller_appid
  public_network = each.value.public_network
  ip             = each.value.ip

  depends_on = [tencentcloud_ckafka_instance.this]
}

################################################################################
# CKafka User
################################################################################
resource "tencentcloud_ckafka_user" "this" {
  for_each = var.users

  instance_id  = tencentcloud_ckafka_instance.this[each.value.instance_key].id
  account_name = each.value.account_name
  password     = each.value.password

  depends_on = [tencentcloud_ckafka_instance.this]
}

################################################################################
# CKafka ACL
################################################################################
resource "tencentcloud_ckafka_acl" "this" {
  for_each = var.acls

  instance_id     = tencentcloud_ckafka_instance.this[each.value.instance_key].id
  resource_type   = each.value.resource_type
  resource_name   = each.value.resource_name
  operation_type  = each.value.operation_type
  permission_type = each.value.permission_type
  host            = each.value.host
  principal       = each.value.principal

  depends_on = [tencentcloud_ckafka_instance.this]
}
