################################################################################
### CAM OIDC config data source
################################################################################
data "tencentcloud_cam_oidc_config" "this" {
  name = var.name

  result_output_file = var.result_output_file
}
