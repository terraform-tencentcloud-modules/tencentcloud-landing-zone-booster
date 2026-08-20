locals {
  policies  = [
    "102693096", # QcloudAccessForCloudAuditRoleInMultipleaccountTrailDelivery
    "18150187",  # QcloudAccessForCARole
    "12031968",  # QcloudASReadOnlyAccess
    "1242979",   # QcloudCDBInnerReadOnlyAccess
    "596170",    # QcloudCamReadOnlyAccess
    "244869",    # QcloudCOSReadOnlyAccess
    "243334",    # QcloudCVMReadOnlyAccess
    "219851",    # QcloudCLBReadOnlyAccess
    "186457"     # QcloudVPCReadOnlyAccess
  ]
}

resource "tencentcloud_cam_role" "role" {
  count         = var.create_cam_strategy ? 1 : 0
  name          = "CloudAudit_QCSRole"
  document      = <<EOF
  {
    "version": "2.0",
    "statement": [
      {
        "action": ["name/sts:AssumeRole"],
        "effect": "allow",
        "principal": {
          "service": "cloudaudit.cloud.tencent.com"
        }
      }
    ]
  }
  EOF
  description   = "Cloud Audit permissions (including but not limited to): CAM(QcloudCamReadOnlyAccess );CVM(QcloudCVMReadOnlyAccess);VPC(QcloudVPCReadOnlyAccess);MySQL(QcloudCDBInnerReadOnlyAccess);CLB(QcloudCLBReadOnlyAccess);AS(QcloudASReadOnlyAccess);COS(QcloudCOSReadOnlyAccess,put bucket);CMQ(add/query queue); KMS(add/query key)."
  console_login = true
  tags = {
    createdBy = "Terragrunt"
  }
}

resource "tencentcloud_cam_role_policy_attachment" "role_policies" {
  count = var.create_cam_strategy ? length(local.policies) : 0

  role_id   = tencentcloud_cam_role.role.0.id
  policy_id = local.policies[count.index]

  depends_on = [
    tencentcloud_cam_role.role,
  ]
}