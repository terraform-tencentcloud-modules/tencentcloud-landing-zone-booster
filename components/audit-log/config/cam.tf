resource "tencentcloud_cam_service_linked_role" "role" {
  count = var.create_cam_strategy ? 1 : 0

  qcs_service_name = ["configrecorder.config.cloud.tencent.com"]
  description      = "The current role is the Config service linked role, which will access your other service resources within the scope of the permissions of the associated policy."
}