variable "ccn_id" {
  type        = string
  description = "CCN instance ID"
}

variable "route_tables" {
  description = "CCN Route tables"
  type = list(object({
    name = string
    desc = string
  }))
}

variable "input_policies" {
  description = "CCN Route table input policies"
  type = list(object({
    route_table_name = string
    policies = list(object({
      action = string # Routing behavior: 'accept' or 'drop'.
      desc   = string
      route_conditions = list(object({
        name          = string      # Condition type. Example value: instance-type, instance-region, instance-id, cidr-block.
        values        = set(string) # List of conditional values. Example value: instance-type: VPC, VPNGW, DIRECTCONNECT instance-region: ap-guangzhou instance-id: vpc-axrsmmrv, dcg-oxad32f7, vpngw-33p5vnwd cidr-block: 172.0.0.0/8
        match_pattern = number      # Matching mode, 1 precise matching, 0 fuzzy matching.
      }))
    }))
  }))
  default = []
}

variable "associate_instances" {
  description = "CCN Route table attach instances"
  type = list(object({
    route_table_name = string
    instances = list(object({
      instance_id   = string
      instance_type = string
    }))
  }))
  default = []
}

variable "broadcast_policies" {
  description = "CCN Route table broadcast policies"
  type = list(object({
    route_table_name = string
    policies = list(object({
      action = string # Routing behavior, accept or drop.
      desc   = string
      route_conditions = list(object({
        name          = string      #Condition type. Example value: instance-type, instance-region, instance-id, cidr-block.
        values        = set(string) #List of conditional values. Example value: instance-type: VPC, VPNGW, DIRECTCONNECT instance-region: ap-guangzhou instance-id: vpc-axrsmmrv, dcg-oxad32f7, vpngw-33p5vnwd cidr-block: 172.0.0.0/8
        match_pattern = number      #Matching mode, 1 precise matching, 0 fuzzy matching.
      }))
      broadcast_conditions = list(object({
        name          = string      #Condition type. Example value: instance-type, instance-region, instance-id, cidr-block.
        values        = set(string) #List of conditional values. Example value: instance-type: VPC, VPNGW, DIRECTCONNECT instance-region: ap-guangzhou instance-id: vpc-axrsmmrv, dcg-oxad32f7, vpngw-33p5vnwd cidr-block: 172.0.0.0/8
        match_pattern = number      #Matching mode, 1 precise matching, 0 fuzzy matching.
      }))
    }))
  }))
  default = []
}
