resource "tencentcloud_apm_sample_config" "this" {
  # required
  instance_id  = var.instance_id
  service_name = var.service_name
  sample_name  = var.sample_name
  sample_rate  = var.sample_rate

  # optional
  operation_name = var.operation_name
  operation_type = var.operation_type

  dynamic tags {
    for_each = { for idx, item in var.tags : idx => item }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}