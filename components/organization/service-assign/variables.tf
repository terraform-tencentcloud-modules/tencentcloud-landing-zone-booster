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
    # Service ID | Service Name                   | Description 
    # 28         | WAF (Web Application Firewall) | The organization management account or service delegated administrator can manage WAF resources for all organization members in WAF.
    # 23         | CSIP (Cloud Security Center)   | The cloud security integrated platform can centrally manage the security risks of multiple accounts within an enterprise, helping users achieve proact
    # 29         | KMS (Key Management Service)   | The group management account or the delegated administrator configured for the KMS service can manage account groups in the Key Management System (KMS). They can enable KMS services for group members, as well as view and manage key resources of other members.
    # 24         | Control Center                 | Support unified management and setup of enterprise multi-account environment. Manage account usage specification.
    # 12         | CloudAudit                     | Cloud audit administrators can use tracking set delivery to track the audit logs of all members in cloud audit.
    # 13         | Billing Center                 | Facilitate financial administrators in accessing members' billing statements, account balances, and bill consolidation.
    # 18         | Config                         | Configuration auditing (Config) helps you centrally audit and manage cloud resources. It continuously records and evaluates the configuration inform
    # 27         | Quota Center                   | The quota center centrally manages cloud service quotas.
    # 30         | Firewall Manager (FWM)         | Support unified policy management, control, and analysis across multiple products and accounts, as well as resource sharing across different account specifications.
    # 25         | Identity Center Management     | The Identity Center provides unified identity and permission management for multi-account based on the Group Account Organizational Structure. By using the Identity Center feature of organization account management, you can manage Tencent Cloud's users in a corporate environment uniformly, configure the enterprise identity management system and Tencent Cloud's SSO in one-time configuration, and configure user access permission to multi-account in a unified way.
    service_name = string
  }))
}