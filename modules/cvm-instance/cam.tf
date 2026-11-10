# QcloudKMSAccessForCVMRole
resource "tencentcloud_cam_role" "QcsRole" {
  count       = var.create_kms_strategy ? 1 : 0
  name        = "CVM_QcsRole"
  document    = <<EOF
{
  "statement": [
    {
      "action":"name/sts:AssumeRole",
      "effect":"allow",
      "principal":{
        "service":"cvm.qcloud.com"
      }
    }
  ],
  "version":"2.0"
}
EOF
  description = "The current role is the CVM service role, which will access your other service resources within the scope of the permissions of the associated policy."
}

resource "tencentcloud_cam_role_policy_attachment" "role_policies" {
  count = var.create_kms_strategy ? 1 : 0

  role_id   = lookup(tencentcloud_cam_role.QcsRole.0, "id")
  policy_id = "951635" # QcloudKMSAccessForCVMRole
}