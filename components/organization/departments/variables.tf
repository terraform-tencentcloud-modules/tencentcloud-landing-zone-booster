variable "org_nodes" {
  description = "l1, l2 node starts from root"
  type = list(object({
    parent_id = optional(number, null)
    name      = string
    remark    = optional(string)
    sub_nodes = optional(list(object({
      name   = string
      remark = optional(string)
    })), [])
  }))
  default = []
}