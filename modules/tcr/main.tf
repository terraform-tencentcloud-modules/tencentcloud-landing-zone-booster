################################################################################
### TCR Instance, Token, Service Accounts, VPC Attachment
################################################################################
resource "tencentcloud_tcr_instance" "registry" {
  name          = var.instance_config.name
  instance_type = var.instance_config.type
  delete_bucket = var.instance_config.delete_bucket

  registry_charge_type                    = var.instance_config.charge_type
  instance_charge_type_prepaid_period     = var.instance_config.charge_type == 2 ? var.instance_config.prepaid_period : null
  instance_charge_type_prepaid_renew_flag = var.instance_config.charge_type == 2 ? var.instance_config.prepaid_renew_flag : null

  open_public_operation = var.instance_config.enable_internet_access

  dynamic "security_policy" {
    for_each = var.instance_config.security_policies
    content {
      cidr_block  = security_policy.value.cidr_block
      description = security_policy.value.description
    }
  }

  tags = var.tags
}

resource "tencentcloud_tcr_vpc_attachment" "vpc_attachmen" {
  for_each = { for id in coalesce(var.vpc_attachment_config.vpc_subnet_pairs, []) : id.subnet_id => id }

  instance_id              = tencentcloud_tcr_instance.registry.id
  vpc_id                   = each.value.vpc_id
  subnet_id                = each.value.subnet_id
  enable_public_domain_dns = each.value.enable_public_domain_dns
  enable_vpc_domain_dns    = each.value.enable_vpc_domain_dns
  region_name              = var.vpc_attachment_config.region
}

resource "tencentcloud_tcr_namespace" "namespace" {
  for_each = { for item in var.tcr_namespaces : item.name => item }

  instance_id    = tencentcloud_tcr_instance.registry.id
  name           = each.value.name
  is_public      = each.value.is_public
  is_auto_scan   = each.value.is_auto_scan
  is_prevent_vul = each.value.is_prevent_vul
  #severity       = each.value.severity
}

resource "time_sleep" "wait_minutes" {
  depends_on = [tencentcloud_tcr_namespace.namespace]

  create_duration = "90s"
}

resource "tencentcloud_tcr_repository" "repository" {
  for_each = { for item in var.tcr_repositories : "${item.namespace_name}-${item.repository_name}" => item }

  instance_id    = tencentcloud_tcr_instance.registry.id
  namespace_name = each.value.namespace_name
  name           = each.value.repository_name
  brief_desc     = each.value.brief_desc
  description    = each.value.description
  depends_on = [
    time_sleep.wait_minutes
  ]
}

# TCR Service Accounts
resource "tencentcloud_tcr_service_account" "service_acount" {
  for_each = { for item in var.tcr_service_accounts : item.account_name => item }

  registry_id = tencentcloud_tcr_instance.registry.id
  name        = each.value.account_name
  dynamic "permissions" {
    for_each = each.value.permissions
    content {
      resource = permissions.value.namespace
      actions  = permissions.value.permission_type == 1 ? ["tcr:PushRepository", "tcr:PullRepository", "tcr:CreateRepository", "tcr:CreateHelmChart", "tcr:DescribeHelmCharts"] : ["tcr:PullRepository", "tcr:DescribeHelmCharts"]
    }
  }
  description = each.value.description
  duration    = each.value.duration
  expires_at  = each.value.expires_at
  disable     = each.value.disable
  password    = each.value.password

  tags = var.tags
}

################################################################################
### SSM Secret for TCR Service Account Credentials
################################################################################
resource "tencentcloud_ssm_secret" "service_account_creds" {
  for_each = var.store_credentials_in_ssm ? { for item in var.tcr_service_accounts : item.account_name => item } : {}

  secret_name = "tcr-${var.instance_config.name}-sa-${each.key}-secret"
  description = "TCR service account credentials for ${each.key}"
  tags        = var.tags

  depends_on = [tencentcloud_tcr_service_account.service_acount]
}

resource "tencentcloud_ssm_secret_version" "service_account_creds_version" {
  for_each = var.store_credentials_in_ssm ? { for item in var.tcr_service_accounts : item.account_name => item } : {}

  secret_name = tencentcloud_ssm_secret.service_account_creds[each.key].secret_name
  version_id  = "v1"
  secret_string = jsonencode({
    registry_id          = tencentcloud_tcr_instance.registry.id
    service_account_name = "tcr@${tencentcloud_tcr_service_account.service_acount[each.key].name}"
    password             = tencentcloud_tcr_service_account.service_acount[each.key].password
  })
}
