resource "tencentcloud_clb_redirection" "redirection" {
  count = length(var.clb_redirections)

  clb_id                  = var.clb_redirections[count.index].clb_id
  target_listener_id      = var.clb_redirections[count.index].target_listener_id
  target_rule_id          = var.clb_redirections[count.index].target_rule_id
  source_listener_id      = try(var.clb_redirections[count.index].source_listener_id, null)
  source_rule_id          = try(var.clb_redirections[count.index].source_rule_id, null)
  delete_all_auto_rewrite = try(var.clb_redirections[count.index].delete_all_auto_rewrite, null)
  is_auto_rewrite         = try(var.clb_redirections[count.index].is_auto_rewrite, null)
}