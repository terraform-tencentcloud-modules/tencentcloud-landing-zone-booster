# QcloudKMSAccessForCVMRole
resource "tencentcloud_cam_role" "QcsRole" {
  count       = var.create_kms_strategy ? 1 : 0
  name        = "MySQL_QCSRole"
  document    = <<EOF
{
  "statement": [
    {
      "action":"name/sts:AssumeRole",
      "effect":"allow",
      "principal":{
        "service":"cdb.qcloud.com"
      }
    }
  ],
  "version":"2.0"
}
EOF
  description = "MySQL permissions (including but not limited to):KMS(create master key,generate data key, decrypt data,obtain the list rules of master key,and bind or unbind cloud resources)."
}

resource "tencentcloud_cam_role_policy_attachment" "role_policies" {
  count = var.create_kms_strategy ? 1 : 0

  role_id   = lookup(tencentcloud_cam_role.QcsRole.0, "id")
  policy_id = "28336545" # QcloudAccessForMySQLRole
}