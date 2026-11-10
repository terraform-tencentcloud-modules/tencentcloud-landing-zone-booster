variable "route_table_id" {
  description = "The ID of the route table (rtb-xxxxxxxx)"
  type        = string
}

variable "route_item_ids" {
  description = "List of route item IDs to publish to CCN (rti-xxxxxxxx format)"
  type        = list(string)
  default     = []
}
