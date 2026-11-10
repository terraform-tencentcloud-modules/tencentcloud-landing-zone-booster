output "redirection_ids" {
  value = tencentcloud_clb_redirection.redirection.*.id
  description = "ID list of the clb redirections"
}