################################################################################
# CCN config
################################################################################
variable "ccn_instance" {
  description = "CCN instance variables."
  type = object({
    name                   = string
    desc                   = optional(string, "The CCN instance created by Terraform.")
    # (Optional, String, ForceNew) CCN service quality, 'PT': Platinum, 'AU': Gold, 'AG': Silver. The default is 'AU'.
    qos                    = optional(string, "AU")
    # (Optional, String) Billing type. Valid values: 'PREPAID', 'POSTPAID'. Default: 'PREPAID'.
    charge_type            = optional(string, "POSTPAID")
    # (Optional, String) Bandwidth limit type. Valid values: 'INTER_REGION_LIMIT', 'OUTER_REGION_LIMIT'. Default: 'OUTER_REGION_LIMIT'.
    bandwidth_limit_type   = optional(string, "INTER_REGION_LIMIT")
    # (Optional, Bool) Whether to enable the equivalent routing function. true: enabled, false: disabled. Default: false.
    enable_route_ecmp      = optional(bool, false)
    # (Optional, Bool) Whether to enable the routing overlap function. true: enabled, false: disabled. Default is true, cannot set to false.
    enable_route_overlap   = optional(bool, true)
    # (Optional, String) Billing mode of the instance. Valid values: 'BANDWIDTH' (billed by bandwidth), 'TRAFFIC' (billed by traffic). Default: 'BANDWIDTH'.
    instance_metering_type = optional(string, "BANDWIDTH")
    # (Optional, Map(String)) Tags of the CCN instance.
    tags                   = optional(map(string), {})
  })
}

variable "ccn_route_tables" {
  description = "CCN Route tables"
  type = map(object({
    name = string
    desc = string
  }))
  default = {}
}

variable "ccnrt_input_policies" {
  description = "CCN Route table input policies"
  type = map(object({
    route_table_name = string
    policies = list(object({
      # (Required, String) Routing behavior. Valid values: 'accept' (allows), 'drop' (rejects).
      action = string
      desc   = string
      route_conditions = list(object({
        # (Required, String) Condition type. Example values: 'instance-type', 'instance-region', 'instance-id', 'cidr-block'.
        name          = string
        # (Required, Set of String) List of conditional values. Example values: instance-type: 'VPC', 'VPNGW', 'DIRECTCONNECT'; instance-region: 'ap-guangzhou'; instance-id: 'vpc-axrsmmrv', 'dcg-oxad32f7', 'vpngw-33p5vnwd'; cidr-block: '172.0.0.0/8'.
        values        = set(string)
        # (Required, Number) Matching mode. Valid values: 1 (precise matching), 0 (fuzzy matching).
        match_pattern = number
      }))
    }))
  }))
  default = {}
}

variable "ccnrt_broadcast_policies" {
  description = "CCN Route table broadcast policies"
  type = map(object({
    route_table_name = string
    policies = list(object({
      # (Required, String) Routing behavior. Valid values: 'accept' (allows), 'drop' (rejects).
      action = string
      desc   = string
      route_conditions = list(object({
        # (Required, String) Condition type. Example values: 'instance-type', 'instance-region', 'instance-id', 'cidr-block'.
        name          = string
        # (Required, Set of String) List of conditional values. Example values: instance-type: 'VPC', 'VPNGW', 'DIRECTCONNECT'; instance-region: 'ap-guangzhou'; instance-id: 'vpc-axrsmmrv', 'dcg-oxad32f7', 'vpngw-33p5vnwd'; cidr-block: '172.0.0.0/8'.
        values        = set(string)
        # (Required, Number) Matching mode. Valid values: 1 (precise matching), 0 (fuzzy matching).
        match_pattern = number
      }))
      broadcast_conditions = list(object({
        # (Required, String) Condition type. Example values: 'instance-type', 'instance-region', 'instance-id', 'cidr-block'.
        name          = string
        # (Required, Set of String) List of conditional values. Example values: instance-type: 'VPC', 'VPNGW', 'DIRECTCONNECT'; instance-region: 'ap-guangzhou'; instance-id: 'vpc-axrsmmrv', 'dcg-oxad32f7', 'vpngw-33p5vnwd'; cidr-block: '172.0.0.0/8'.
        values        = set(string)
        # (Required, Number) Matching mode. Valid values: 1 (precise matching), 0 (fuzzy matching).
        match_pattern = number
      }))
    }))
  }))
  default = {}
}

# ============================================================================
# CCN Attachment Configuration (Initiate Attachment)
# ============================================================================
variable "ccn_attachments" {
  description = "Configuration for creating a CCN attachment. Set to null to skip attachment creation."
  type = list(object({
    ccn_id           = optional(string)      # (Required) CCN instance ID
    ccn_uin          = optional(string)      # (Required) CCN instance UIN
    instance_id      = string                # (Required) Network instance ID (VPC ID, VPN Gateway ID, etc.)
    instance_region  = string                # (Required) Network instance region
    instance_type    = string                # (Required) Type: VPC, VPNGW, DIRECTCONNECT, BMVPC, EDGE
    description      = optional(string, "")  # (Optional) Description of the attachment
    route_table_id   = optional(string)      # (Optional) CCN route table ID to associate with
    route_table_name = optional(string)      # (Optional) CCN route table Name to associate with
  }))
  default = []
  validation {
    condition = alltrue([
      for att in var.ccn_attachments : contains(["VPC", "VPNGW", "DIRECTCONNECT", "BMVPC", "EDGE"], att.instance_type)
    ])
    error_message = "Each ccn_attachments.instance_type must be one of: VPC, VPNGW, DIRECTCONNECT, BMVPC, EDGE."
  }
}

# ============================================================================
# CCN Attachment Accept Configuration
# ============================================================================
variable "ccn_accept_attachments" {
  description = "Configuration for accepting a CCN attachment request. Used by CCN owner to accept attachment requests from other accounts. Set to null to skip acceptance operation."
  type = list(object({
    ccn_id          = optional(string)      # (Required) CCN instance ID
    instance_id     = string                # (Required) Network instance ID to accept
    instance_type   = string                # (Required) Type: VPC, VPNGW, DIRECTCONNECT, BMVPC, EDGE
    instance_region = string                # (Required) Network instance region
    description     = optional(string, "")  # (Optional) Description for the acceptance
  }))
  default = []
  validation {
    condition = alltrue([
      for att in var.ccn_accept_attachments : contains(["VPC", "VPNGW", "DIRECTCONNECT", "BMVPC", "EDGE"], att.instance_type)
    ])
    error_message = "accept_attachment.instance_type must be one of: VPC, VPNGW, DIRECTCONNECT, BMVPC, EDGE."
  }
}

# ============================================================================
# CCN Attachment Reject Configuration
# ============================================================================
variable "ccn_reject_attachments" {
  description = "Configuration for rejecting a CCN attachment request. Used by CCN owner to reject attachment requests from other accounts. Set to null to skip rejection operation."
  type = list(object({
    ccn_id          = optional(string)      # (Required) CCN instance ID
    instance_id     = string                # (Required) Network instance ID to reject
    instance_type   = string                # (Required) Type: VPC, VPNGW, DIRECTCONNECT, BMVPC, EDGE
    instance_region = string                # (Required) Network instance region
    description     = optional(string, "")  # (Optional) Description for the rejection
  }))
  default = []

  validation {
    condition = alltrue([
      for att in var.ccn_reject_attachments : contains(["VPC", "VPNGW", "DIRECTCONNECT", "BMVPC", "EDGE"], att.instance_type)
    ])
    error_message = "reject_attachment.instance_type must be one of: VPC, VPNGW, DIRECTCONNECT, BMVPC, EDGE."
  }
}

# ============================================================================
# CCN Attachment Reset Configuration
# ============================================================================
variable "ccn_reset_attachments" {
  description = "Configuration for resetting a CCN attachment state. Used to reset attachment state back to pending. Set to null to skip reset operation."
  type = list(object({
    ccn_id          = optional(string)      # (Required) CCN instance ID
    ccn_uin         = optional(string)      # (Required) CCN instance UIN
    instance_id     = string                # (Required) Network instance ID to reset
    instance_type   = string                # (Required) Type: VPC, VPNGW, DIRECTCONNECT, BMVPC, EDGE
    instance_region = string                # (Required) Network instance region
    description     = optional(string, "")  # (Optional) Description for the reset
  }))
  default = []
  validation {
    condition = alltrue([
      for att in var.ccn_reset_attachments : contains(["VPC", "VPNGW", "DIRECTCONNECT", "BMVPC", "EDGE"], att.instance_type)
    ])
    error_message = "reset_attachment.instance_type must be one of: VPC, VPNGW, DIRECTCONNECT, BMVPC, EDGE."
  }
}