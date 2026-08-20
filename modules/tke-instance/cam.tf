locals {
  tke_qcsrole_policies  = [
    "150531903", # QcloudAccessForTKERoleInGroupsForUser
    "220150018", # QcloudAccessFortkeRoleInMetricsbyLog
    "164010336", # QcloudAccessForTKERoleInKMSKeyInfo
    "157585386", # QcloudAccessForTKERoleInCOSObject
    "92631421",  # QcloudAccessForTKERoleInCost
    "62665329",  # QcloudAccessForTKERoleInECVM
    "34488263",  # QcloudAccessForTKERoleInOpsManagement
    "29548861",  # QcloudAccessForTKERoleInCreatingCFSStorageclass
    "142089923", # QcloudAccessForTKERoleInOIDCConfig
    "9087631",   # QcloudAccessForTKERole
    "450012"     # QcloudCVMFinanceAccess
  ]
}

resource "tencentcloud_cam_role" "TKE_QCSRole" {
  count       = var.create_cam_strategy ? 1 : 0
  name        = "TKE_QCSRole"
  document    = <<EOF
{
  "statement": [
    {
      "action":"sts:AssumeRole",
      "effect":"allow",
      "principal":{
        "service":"ccs.qcloud.com"
      }
    }
  ],
  "version":"2.0"
}
EOF
  description = "The current role is the TKE service role, which will access your other service resources within the scope of the permissions of the associated policy."
}

resource "tencentcloud_cam_role_policy_attachment" "role_policies" {
  count = var.create_cam_strategy ? length(local.tke_qcsrole_policies) : 0

  role_id   = lookup(tencentcloud_cam_role.TKE_QCSRole.0, "id")
  policy_id = local.tke_qcsrole_policies[count.index]

  depends_on = [ tencentcloud_cam_role.TKE_QCSRole ]
}

# IPAMDofTKE_QCSRole
resource "tencentcloud_cam_role" "ipamd_role" {
  count       = var.create_cam_strategy_ipamd ? 1 : 0

  name          = "IPAMDofTKE_QCSRole"
  description   = "TKE IPAMD permissions (including but not limited to): CVM (query CVM info); VPC (add/delete/query VPC ENI); Tag (create tags for ENIs and query ENI info via tags)."
  document = jsonencode({
    version = "2.0"
    statement = [{
      action    = "sts:AssumeRole"
      effect    = "allow"
      principal = { service = ["ccs.qcloud.com"] }
    }]
  })
}

data "tencentcloud_cam_policies" "tke_ipamd_role" {
  name = "QcloudAccessForIPAMDofTKERole"
}

resource "tencentcloud_cam_role_policy_attachment" "ipamd_tke" {
  count = var.create_cam_strategy_ipamd ? 1 : 0

  role_id   = lookup(tencentcloud_cam_role.ipamd_role.0, "id")
  policy_id = lookup(data.tencentcloud_cam_policies.tke_ipamd_role.policy_list.0, "policy_id")
}