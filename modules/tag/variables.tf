variable "tags" {
  description = "Controls if tag should be created."
  type = list(object({
    key   = string # tag key
    value = string # tag value
  }))
}