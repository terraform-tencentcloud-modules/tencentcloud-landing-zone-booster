resource "null_resource" "redeploy_trigger" {
  count = var.create && var.deployment_status == "DeployedRequired" ? 1 : 0
  triggers = {
    always_run = timestamp()
  }
}

resource "tencentcloud_provision_role_configuration_operation" "provision_role_configuration_operation" {
  count = var.create && var.deployment_status == "DeployedRequired" ? 1 : 0
  zone_id               = var.zone_id
  role_configuration_id = var.role_id
  target_type           = var.target_type
  target_uin            = var.target_uin

  lifecycle {
    replace_triggered_by = [
      null_resource.redeploy_trigger
    ]
  }
}