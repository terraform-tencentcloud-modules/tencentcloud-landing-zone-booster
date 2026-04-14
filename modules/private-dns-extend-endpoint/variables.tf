variable "create" {
  type        = bool
  default     = true
  description = "Create or use an existed one"
}

variable "end_point_name" {
  type = string
  default = ""
  description = "Endpoint name"
}

variable "end_point_region" {
  default = ""
  type = string
  description = "Endpoint region, which should be consistent with the region of the endpoint service."
}

variable "forward" {
  description = "The configuration block for forwarding IP"
  type = object({
    access_type       = string
    host              = string
    port              = number
    vpc_id            = string
    access_gateway_id = string
  })
  default = {
    access_type       = "CLB" # "CLB", "CCN"
    host              = ""    # "1.1.1.1"
    port              = 8080  # 8080
    vpc_id            = ""    # "vpc-2qjckjg2"
    access_gateway_id = ""    # "ccn-eo13f8ub"
  }
}