# Get members information
data "tencentcloud_organization_members" "members" {}

# Get region information
data "tencentcloud_regions" "regions" {
  product = "vpc"
}

data "tencentcloud_cam_roles" "ccrole" {
  name = "ControlCenter_QCSLinkedRoleInAccountsEntMng"
}

resource "tencentcloud_cam_service_linked_role" "cc_role" {
  count = length(local.role_list) == 0 ? 1 : 0

  qcs_service_name = ["accountsentmng.controlcenter.cloud.tencent.com"]
  description      = "The current role is the ControlCenter service linked role, which will access your other service resources within the scope of the permissions of the associated policy."
  tags             = {CreatedBy = "Terraform"}
}

locals {
  # get all roles
  role_list = data.tencentcloud_cam_roles.ccrole.role_list

  baseline_identifier_password       = "TCC-AF_CAM_USER_PASSWORD_POLICY"
  baseline_identifier_security       = "TCC-AF_CAM_USER_SECURITY"
  baseline_identifier_contact        = "TCC-AF_ACCOUNT_CONTACT"
  baseline_identifier_preset_tag     = "TCC-AF_PRESET_TAG"
  baseline_identifier_security_group = "TCC-AF_SECURITY_GROUP"
  baseline_identifier_vpc_subnet     = "TCC-AF_VPC_SUBNET"

  org_members = {
    for m in data.tencentcloud_organization_members.members.items : m.name => m.member_uin
  }

  member_uin_list = [
    for item in var.member_list : 
      item.member_uin != null ? item.member_uin : local.org_members[item.member_name]
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
  count = length(local.member_uin_list) > 0 ? 1 : 0

  member_uin_list = local.member_uin_list

  dynamic "baseline_config_items" {
    for_each = [ for item in local.baseline_items : { identifier = item.identifier, configuration = item.configuration} ]
    content {
      identifier    = baseline_config_items.value.identifier
      configuration = baseline_config_items.value.configuration
    }
  }

  depends_on = [ tencentcloud_controlcenter_account_factory_baseline_config.this ]
}