# Role: MongoDB_QCSLinkedRoleInKMS
# Policy: QcloudAccessForMongoDBLinkedRoleInKMS
resource "tencentcloud_cam_service_linked_role" "role" {
  count = var.create_kms_strategy ? 1 : 0

  qcs_service_name = ["kms.mongodb.cloud.tencent.com"]
  description      = "The current role is the MongoDB service linked role, which will access your other service resources within the scope of the permissions of the associated policy."
}