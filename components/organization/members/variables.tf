variable "members" {
  description = "A map of organization members. Key is unique node name."
  type = map(list(object({
    # user info
    name           = string       # Member name
    permission_ids = list(number) # Financial management permission IDs.Valid values:- 1: View bill.- 2: Check balance.- 3: Fund transfer.- 4: Combine bill.- 5: Issue an invoice.- 6: Inherit discount.- 7: Pay on behalf.value 1,2 is required.
    policy_type    = string       # Organization policy type.- Financial: Financial management policy.
    pay_uin        = string       # The uin which is payment account on behalf.When PermissionIds contains 7, is required.
    # optional
    node_id              = optional(number, null) # Organization node ID.
    force_delete_account = optional(bool, false)  # Whether to force delete the member account when deleting the organization member. It is only applicable to member accounts of the creation type, not to member accounts of the invitation type. Default is false.
    is_modify_nick_name  = optional(number)       # Whether to synchronize organization member names to their account nicknames. Values: 1 - Sync, 0 - Do not sync. This parameter takes effect only when the name field is being modified.
    record_id            = optional(number)       # Create member record ID.When create failed and needs to be recreated, is required.
    remark               = optional(string)       # remark
    tags                 = optional(map(string))  # member tags
    # security information
    enable_bound         = optional(bool, false)   # default false, security information bound，An activation email will be sent to this email address after binding.
    email                = optional(string) # The email address of the user or contact person.
    phone                = optional(string) # The phone number of the user or contact person.
    country_code         = optional(number) # The country code for the phone number (e.g., 86 for China).
  })))
  default = {}
}