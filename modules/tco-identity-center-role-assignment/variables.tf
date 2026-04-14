variable "create" {
  type = bool
  default = true
  description = "create or not"
}
variable "zone_id" {
  type = string
  default = ""
  description = "cic zone id, copy from console"
}

variable "assignments" {
  description = "A map of role assignments. Key is the assignment name, value is an assignment object."
  type = map(object({
    principal_id          = string # user or group id to sync cam role ans user
    principal_type        = string # User: indicates that the identity for the CAM user synchronization is a CIC user. Group: indicates that the identity for the CAM user synchronization is a CIC user group.
    target_uin            = number # UIN of the synchronized target account of the Tencent Cloud Organization.
    target_type           = string # Type of the synchronized target account of the Tencent Cloud Organization. ManagerUin: admin account; MemberUin: member account.
    role_configuration_id = string # ID of the CAM role configuration.
  }))
  default = {
    example = {
      principal_id          = "u-20000001"
      principal_type        = "Group"
      target_uin            = 100000001
      target_type           = "MemberUin"
      role_configuration_id = "rc-30000001"
    }
  }
}