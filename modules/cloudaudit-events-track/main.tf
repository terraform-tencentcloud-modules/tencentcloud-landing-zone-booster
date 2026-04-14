locals {
  policies  = [
    "102693096", "18150187", "12031968", "1242979", "596170", "244869", "243334", "219851", "186457"]
}

resource "tencentcloud_cam_role" "role" {
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
  count = length(local.policies)

  role_id   = tencentcloud_cam_role.role.id
  policy_id = local.policies[count.index]

  depends_on = [
    tencentcloud_cam_role.role,
  ]
}

resource "tencentcloud_events_audit_track" "events_track" {
  name                  = var.track_name
  status                = var.status
  track_for_all_members = var.track_for_all_members

  storage {
    storage_name       = var.storage_name
    storage_prefix     = var.storage_prefix
    storage_region     = var.storage_type
    storage_type       = var.storage_region
    storage_account_id = var.storage_account_id
    storage_app_id     = var.storage_app_id
  }

  filters {
    dynamic "resource_fields" {
      for_each = var.audit_filters
      content {
        resource_type = resource_fields.value.resource_type
        action_type   = resource_fields.value.action_type
        event_names   = resource_fields.value.event_names
      }
    }
  }
  
  depends_on = [
    tencentcloud_cam_role.role,
    tencentcloud_cam_role_policy_attachment.role_policies,
  ]
}