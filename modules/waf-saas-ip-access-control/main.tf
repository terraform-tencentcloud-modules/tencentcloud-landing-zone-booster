resource "tencentcloud_waf_saas_ip_access_control" "tc_waf_saas_ip_access_control" {
  action_type = var.action_type
  domain      = var.domain
  instance_id = var.instance_id
  ip_list     = var.ip_list
  job_type    = var.job_type
  note        = var.note

  # Dynamic block for scheduled configuration
  dynamic "job_date_time" {
    for_each = var.job_date_time
    content {
      time_t_zone = job_date_time.value.time_t_zone

      # Dynamic block for cron configuration
      dynamic "cron" {
        for_each = job_date_time.value.cron != null ? job_date_time.value.cron : []
        content {
          days      = cron.value["days"]
          end_time  = cron.value["end_time"]
          start_time = cron.value["start_time"]
          w_days    = cron.value["w_days"]
        }
      }

      # Dynamic block for timed configuration
      dynamic "timed" {
        for_each = job_date_time.value.timed != null ? job_date_time.value.timed : []
        content {
          end_date_time   = timed.value["end_date_time"]
          start_date_time = timed.value["start_date_time"]
        }
      }
    }
  }
}