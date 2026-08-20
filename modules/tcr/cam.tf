resource "tencentcloud_cam_role" "tcr_qcs_role" {
  count = var.create_cam_strategy ? 1 : 0

  name          = "TCR_QCSRole"
  description   = "TCR permissions (including but not limited to): COS (create bucket, read/write/delete/copy object, initiate multiple upload); VPC (query VPC and subnet)."
  document = jsonencode({
    version = "2.0"
    statement = [{
      action    = "name/sts:AssumeRole"
      effect    = "allow"
      principal = { service = ["tcr.cloud.tencent.com"] }
    }]
  })
}

data "tencentcloud_cam_policies" "tcr" {
  name = "QcloudAccessForTCRRole"
}

data "tencentcloud_cam_policies" "tcr_in_ssl" {
  name = "QcloudAccessForTCRRoleInSSL"
}

resource "tencentcloud_cam_role_policy_attachment" "attachment_tcr" {
  count = var.create_cam_strategy ? 1 : 0

  role_id   = lookup(tencentcloud_cam_role.tcr_qcs_role.0, "id")
  policy_id = lookup(data.tencentcloud_cam_policies.tcr.policy_list.0, "policy_id")
}

resource "tencentcloud_cam_role_policy_attachment" "attachment_tcr_in_ssl" {
  count = var.create_cam_strategy ? 1 : 0

  role_id   =  lookup(tencentcloud_cam_role.tcr_qcs_role.0, "id")
  policy_id = lookup(data.tencentcloud_cam_policies.tcr_in_ssl.policy_list.0, "policy_id")
}