variable "project_id" {
  description = "Id of the project within the CLB instance, '0' - Default Project."
  type        = number
  default     = 0
}

variable "clb_name" {
  description = "Name of the CLB."
  type        = string
}

variable "network_type" {
  description = "Type of CLB instance."
  type        = string
  default     = "OPEN"
}

variable "vpc_id" {
  description = "VPC ID of the CLB."
  type        = string
}

variable "subnet_id" {
  description = "In the case of purchasing a INTERNAL clb instance, the subnet id must be specified. "
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Specify the subnet availability zone."
  type        = string
  default     = null
}

variable "master_availability_zone" {
  description = "Setting master zone id of cross available zone disaster recovery, only applicable to open CLB."
  type        = string
  default     = null
}

variable "slave_availability_zone" {
  description = "Setting slave zone id of cross available zone disaster recovery, only applicable to open CLB. this zone will undertake traffic when the master is down."
  type        = string
  default     = null
}

variable "delete_protect" {
  description = "Whether to enable delete protection."
  type        = bool
  default     = false # setting to not protected by default
}

variable "address_ip_version" {
  description = "IP version, only applicable to open CLB. Valid values are ipv4, ipv6 and IPv6FullChain."
  type        = string
  default     = null
}

variable "bandwidth_package_id" {
  description = "Bandwidth package id. If set, the internet_charge_type must be BANDWIDTH_PACKAGE."
  type        = string
  default     = null
}

variable "internet_bandwidth_max_out" {
  description = "Max bandwidth out, only applicable to open CLB."
  type        = number
  default     = 10 # 10M
}

variable "internet_charge_type" {
  description = "Internet charge type, only applicable to open CLB."
  type        = string
  default     = "TRAFFIC_POSTPAID_BY_HOUR"
}

variable "enable_pass_to_target" {
  description = "Whether the target allow flow come from clb."
  type        = bool
  default     = true
}

variable "snat_ips" {
  description = "Snat Ip List, required with snat_pro=true. NOTE: This argument cannot be read and modified here because dynamic ip is untraceable, please import resource tencentcloud_clb_snat_ip to handle fixed ips."
  type        = list(map(string))
  default     = []
}

variable "snat_pro" {
  description = "Indicates whether Binding IPs of other VPCs feature switch."
  type        = bool
  default     = null
}

variable "target_region_info_region" {
  description = "Region information of backend services are attached the CLB instance. Only supports OPEN CLBs."
  type        = string
  default     = null
}

variable "target_region_info_vpc_id" {
  description = "Vpc information of backend services are attached the CLB instance. Only supports OPEN CLBs."
  type        = string
  default     = null
}

variable "create_clb_log" {
  description = "Whether to create clb log"
  type        = bool
  default     = false
}

variable "log_set_id" {
  description = " The id of log set."
  type        = string
  default     = null
}

variable "clb_log_set_period" {
  type        = number
  default     = 7
  description = "Logset retention period in days. Maximun value is 90."
}

variable "log_topic_id" {
  description = "The id of log topic."
  type        = string
  default     = null
}

variable "clb_log_topic_name" {
  type        = string
  default     = "clb_topic"
  description = "Log topic of CLB instance."
}

variable "security_groups" {
  description = "Security groups of the CLB instance."
  type        = list(string)
  default     = []
}

variable "sla_type" {
  description = "This parameter is required to create LCU-supported instances."
  type        = string
  default     = null
}

variable "dynamic_vip" {
  description = "Dynamic domain name or static vip."
  type        = bool
  default     = null
}

variable "vip" {
  description = "Specifies the VIP for the application of a CLB instance. This parameter is optional. If you do not specify this parameter, the system automatically assigns a value for the parameter. IPv4 and IPv6 CLB instances support this parameter, but IPv6 NAT64 CLB instances do not."
  default     = null
  type        = string
}

variable "associate_endpoint" {
  description = "The associated terminal node ID; passing an empty string indicates unassociating the node."
  default     = null
  type        = string
}

variable "tags" {
  description = "The available tags within this CLB."
  type        = map(string)
  default     = {}
}