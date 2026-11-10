# Role: Postgres_QCSLinkedRoleInPostgresKms
# Policy: QcloudAccessForPostgresLinkedRoleInPostgresKms
resource "tencentcloud_cam_service_linked_role" "role" {
  count = var.create_kms_strategy ? 1 : 0

  qcs_service_name = ["postgreskms.postgres.cloud.tencent.com"]
  description      = "The current role is the PostgreSQL service linked role, which will access your other service resources within the scope of the permissions of the associated policy."
}