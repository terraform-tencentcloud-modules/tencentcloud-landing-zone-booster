# Get members information
data "tencentcloud_organization_members" "members" {}

# Get region information
data "tencentcloud_regions" "regions" {
  product = "vpc"
}

locals {
  baseline_identifier_password       = "TCC-AF_CAM_USER_PASSWORD_POLICY"
  baseline_identifier_security       = "TCC-AF_CAM_USER_SECURITY"
  baseline_identifier_contact        = "TCC-AF_ACCOUNT_CONTACT"
  baseline_identifier_message        = "TCC-AF_ACCOUNT_NOTIFICATION"
  baseline_identifier_preset_tag     = "TCC-AF_PRESET_TAG"
  baseline_identifier_security_group = "TCC-AF_SECURITY_GROUP"
  baseline_identifier_vpc_subnet     = "TCC-AF_VPC_SUBNET"
  baseline_identifier_shared_image   = "TCC-AF_SHARE_IMAGE"

  org_members = {
    for m in data.tencentcloud_organization_members.members.items : m.name => m.member_uin
  }

  member_uin_list = [
    for item in var.member_list : 
      item.member_uin != null ? item.member_uin : local.org_members[item.member_name]
  ]

  member_uin_chunks = [
    for i in range(0, length(local.member_uin_list), 10) :
    slice(local.member_uin_list, i, min(i + 10, length(local.member_uin_list)))
  ]

  # get all region
  region_list = {
    for region in data.tencentcloud_regions.regions.region_list : region.region => region.region_id_m_c
  }

  baseline_items = concat(
    var.cam_password.enabled ? [{
      identifier    = local.baseline_identifier_password
      configuration = jsonencode({
        "MustContain":         var.cam_password.password_must_contain,
        "MinimumLength":       var.cam_password.password_minimum_length,
        "ForcePasswordChange": var.cam_password.password_force_change,
        "ReusePasswordLimit":  var.cam_password.password_reuse_limit,
        "RetryPasswordLimit":  var.cam_password.password_retry_limit
      })
    }] : [],
    var.cam_security.enabled ? [{
      identifier    = local.baseline_identifier_security
      configuration = jsonencode({
        "DefaultMFASettings": {
            "LoginDetail":    var.cam_security.security_mfa_devices,
            "LoginStrategy":  var.cam_security.security_mfa_login_strategy,
            "ActionStrategy": var.cam_security.security_mfa_action_strategy
        },
        "LoginStatusSettings": {
            "IdleSessionTimeout": var.cam_security.security_login_idle_timeout,
            "SessionTimeout":     var.cam_security.security_login_max_timeout
        }
      })
    }] : [],
    var.account_contact.enabled ? [{
      identifier    = local.baseline_identifier_contact
      configuration = jsonencode({
        "AccountContacts": [
          for item in var.account_contact.contacts : {
            "Name":        item.name,
            "PhoneNum":    item.phone_num,
            "Email":       item.email,
            "Remark":      item.remark,
            "CountryCode": item.country_code
          }
        ]
      })
    }] : [],
    var.account_contact.enabled && var.account_message.enabled ? [{
      identifier    = local.baseline_identifier_message
      configuration = jsonencode({
        "Subscriptions": [
          for item in var.account_message.messages : {
            "MsgType": item.msg_type,
            "Channel": item.channel,
            "Name":    item.names,
          }
        ]
      })
    }] : [],
    var.tag_info.enabled ? [{
      identifier    = local.baseline_identifier_preset_tag
      configuration = jsonencode({
        "TagValuePairs": var.tag_info.tags
      })
    }] : [],
    var.security_group.enabled ? [{
      identifier    = local.baseline_identifier_security_group
      configuration = jsonencode({
        "GroupName":   var.security_group.name,
        "GroupRemark": var.security_group.remark,
        "Region":      var.security_group.region,
        "Ingress": [
          for rule in var.security_group.ingress_rules : {
            "Cidr":     rule.cidr,
            "Protocol": rule.protocol,
            "Port":     rule.port,
            "Remark":   rule.remark,
            "Action":   rule.action,
            "Type":     rule.type
          }
        ],
        "Egress": [
          for rule in var.security_group.egress_rules : {
            "Cidr":     rule.cidr,
            "Protocol": rule.protocol,
            "Port":     rule.port,
            "Remark":   rule.remark,
            "Action":   rule.action,
            "Type":     rule.type
          }
        ]
      })
    }] : [],
    var.vpc_info.enabled ? [{
      identifier    = local.baseline_identifier_vpc_subnet
      configuration = jsonencode({
        "VpcName":    var.vpc_info.name,
        "CidrBlock":  var.vpc_info.cidr,
        "Region":     try(local.region_list[var.vpc_info.region], "")
        "RegionName": var.vpc_info.region,
        "Subnets": [
          for item in var.vpc_info.subnets : {
            "SubnetName": item.subnet_name,
            "CidrBlock":  item.cidr_block,
            "Zone":       item.zone
          }
        ]
      })
    }] : [],
    var.share_image.enabled ? [{
      identifier    = local.baseline_identifier_shared_image
      configuration = jsonencode({
        "Images": [
          for item in var.share_image.images : {
            "Region":    item.region,
            "ImageId":   item.image_id,
            "ImageName": item.image_name,
          }
        ]
      })
    }] : []
  )
}

resource "tencentcloud_controlcenter_account_factory_baseline_config" "this" {
  name = var.baseline_name
  
  dynamic "baseline_config_items" {
    for_each = local.baseline_items
    content {
      identifier    = baseline_config_items.value.identifier
      configuration = baseline_config_items.value.configuration
    }
  }

  depends_on = [
    tencentcloud_cam_service_linked_role.cc_role,
  ]
}

resource "tencentcloud_batch_apply_account_baselines" "baselines" {
  #count = length(local.member_uin_list) > 0 ? 1 : 0
  #member_uin_list = local.member_uin_list

  for_each = { for i, chunk in local.member_uin_chunks : i => chunk }

  member_uin_list = each.value

  dynamic "baseline_config_items" {
    for_each = [ for item in local.baseline_items : { identifier = item.identifier, configuration = item.configuration} ]
    content {
      identifier    = baseline_config_items.value.identifier
      configuration = baseline_config_items.value.configuration
    }
  }

  depends_on = [ tencentcloud_controlcenter_account_factory_baseline_config.this ]
}