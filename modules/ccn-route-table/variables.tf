variable "ccn_id" {
  type        = string
  description = "CCN instance ID"
}

variable "ccn_route_table" {
  description = "CCN Route table config"
  type = object({
    name = string           # Route table name.
    desc = optional(string) # Route table description.

    # CCN route table input policies
    input_policies = optional(list(object({
      action = string           # Routing behavior: 'accept' or 'drop'.
      desc   = optional(string) # Policy description.
      route_conditions = list(object({
        name          = string              # Condition type. Example value: instance-type, instance-region, instance-id, cidr-block.
        values        = list(string)        # List of conditional values. Example value: instance-type: VPC, VPNGW, DIRECTCONNECT instance-region: ap-guangzhou instance-id: vpc-axrsmmrv, dcg-oxad32f7, vpngw-33p5vnwd cidr-block: 172.0.0.0/8
        match_pattern = optional(number, 1) # Matching mode, 1 precise matching, 0 fuzzy matching.
      }))
    })), [])

    # CCN Route table attach instances
    associate_instances = optional(list(object({
      instance_id   = string # Instance ID.
      instance_type = string # Cloud networking supports instance types: VPC, DIRECTCONNECT, BMVPC, EDGE, EDGE_TUNNEL, EDGE_VPNGW, VPNGW.
    })), [])

    # Routing propagation strategy.
    broadcast_policies = optional(list(object({
      action = string           # Routing behavior, `accept` allows, `drop` rejects.
      desc   = optional(string) # Policy description.
      route_conditions = list(object({
        name          = string              # Condition type. Example value: instance-type, instance-region, instance-id, cidr-block.
        values        = list(string)        # List of conditional values. Example value: instance-type: VPC, VPNGW, DIRECTCONNECT instance-region: ap-guangzhou instance-id: vpc-axrsmmrv, dcg-oxad32f7, vpngw-33p5vnwd cidr-block: 172.0.0.0/8
        match_pattern = optional(number, 1) # Matching mode, 1 precise matching, 0 fuzzy matching.
      }))
      broadcast_conditions = list(object({
        name          = string              # Condition type. Example value: instance-type, instance-region, instance-id, cidr-block.
        values        = list(string)        # List of conditional values. Example value: instance-type: VPC, VPNGW, DIRECTCONNECT instance-region: ap-guangzhou instance-id: vpc-axrsmmrv, dcg-oxad32f7, vpngw-33p5vnwd cidr-block: 172.0.0.0/8
        match_pattern = optional(number, 1) # Matching mode, 1 precise matching, 0 fuzzy matching.
      }))
    })), [])
  })
}