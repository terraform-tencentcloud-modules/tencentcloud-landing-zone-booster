resource "tencentcloud_clb_log_set" "this" {
  period = var.logset_period
}

resource "tencentcloud_clb_log_topic" "this" {
  log_set_id = tencentcloud_clb_log_set.this.id
  topic_name = var.log_topic_name
  status     = var.log_topic_status
}

resource "tencentcloud_clb_cls_log_attachment" "example" {
  load_balancer_id = var.clb_instance_id
  log_set_id       = tencentcloud_clb_log_set.this.id
  log_topic_id     = tencentcloud_clb_log_topic.this.id
}