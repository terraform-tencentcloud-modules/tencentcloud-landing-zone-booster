variable "org_nodes" {
  description = "node starts from root"
  type = map(object({
    parent_id = optional(number, null)
    name      = string
    remark    = optional(string)
  }))
}