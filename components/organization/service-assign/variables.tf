variable "management_scope" {
  type        = number
  default     = 1
  description = "Management scope of the delegated admin. Valid values: 1 (all members), 2 (partial members). Default value: `1`."
}

variable "service_assign_list" {
  description = "A list of member and service map. member_uin and member_name must set one."
  type = list(object({
    member_uin   = optional(number, null) # Member UIN
    member_name  = optional(string, null) # Member Name
    # ICP (ID: 22): The group management account or delegated administrator can manage the filing resources in ICP filing in a unified way.
    # Web Application Firewall (ID: 24): The organization management account or service delegated administrator can manage WAF resources for all organization members in WAF.
    # Cloud Security Center (ID: 15): The organization management account or service delegated administrator can manage the CSC resources for all organization members in Cloud Security Center.
    # Cloud Virtual Machine (ID: 23): Manage account or delegated admin account can view all member CVM instance purchase quota and request batch quota increases on their behalf.
    # Key Management Service (ID: 25): The group management account or the delegated administrator configured for the KMS service can manage account groups in the Key Management System (KMS). They can enable KMS services for group members, as well as view and manage key resources of other members.
    # Control Center (ID: 17): Support unified management and configuration of the enterprise's multi-account environment, as well as the management of account usage norms.
    # CloudAudit (ID: 12): The operation audit administrator can use the tracking set to deliver the tracking of all members' audit logs in the operation audit.
    # tandon (ID: 20): The organization management account or service delegated administrator can view and manage the Andon resources of all organization members in Andon.
    # Billing Center (ID: 13): Allow financial administrators to view members' bills, balances, and consolidated statements, etc.
    # Config (ID: 18): The organization management account or service delegated administrator can view and manage the Config resources of all organization members in Config.
    service_name = string
  }))
}