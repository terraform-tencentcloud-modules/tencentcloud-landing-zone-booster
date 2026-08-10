################################################################################
# resource: tencentcloud_kubernetes_cluster
################################################################################
variable "create_cluster" {
  type        = bool
  default     = true
  description = "create cluster or not. If not, must specify a cluster id"
}

variable "cluster_id" {
  type        = string
  default     = ""
  description = "existing cluster id, used when create_cluster is false"
}

variable "create_cam_strategy" {
  type        = bool
  default     = false
  description = "Specify whether to create CAM role and relative TKE essential policy. Set to false if you've enable by using TencentCloud Console."
}

# Networks
variable "vpc_id" {
  type        = string
  default     = null
  description = "Specify the vpc_id of tke cluster."
}

variable "intranet_subnet_id" {
  type        = string
  default     = ""
  description = "Specify custom Subnet id for intranet."
}

variable "network_type" {
  description = "Cluster network type, GR or VPC-CNI. Default is GR."
  type        = string
  default     = "GR"
}

variable "eni_subnet_ids" {
  description = "Subnet Ids for cluster with VPC-CNI network mode. This field can only set when field network_type is 'VPC-CNI'."
  type        = list(string)
  default     = []
}

variable "claim_expired_seconds" {
  type        = number
  default     = 300
  description = "Claim expired seconds to recycle ENI. This field can only set when field network_type is 'VPC-CNI'. claim_expired_seconds must greater or equal than 300 and less than 15768000."
}

variable "cluster_max_service_num" {
  type        = number
  default     = 256
  description = "A network address block of the service. Different from vpc cidr and cidr of other clusters within this vpc. Must be in 10./192.168/172.[16-31] segments."
}

# TKE
variable "cluster_name" {
  type        = string
  default     = "example-cluster"
  description = "TKE managed cluster name."
}

variable "cluster_version" {
  type        = string
  default     = "1.22.5"
  description = "Cluster kubernetes version."
}

variable "cluster_cidr" {
  type        = string
  default     = "172.16.0.0/22"
  description = "Cluster cidr, conflicts with its subnet. set to \"\" when network_type is VPC-CNI"
}

variable "cluster_os" {
  type        = string
  default     = "tlinux2.2(tkernel3)x86_64"
  description = "Cluster operation system image name."
}

variable "container_runtime" {
  type        = string
  default     = "containerd"
  description = "Runtime type of the cluster, the available values include: 'docker' and 'containerd'.The Kubernetes v1.24 has removed dockershim, so please use containerd in v1.24 or higher.Default is 'docker'."
}

variable "cluster_level" {
  type        = string
  default     = "L5"
  description = "Specify cluster level, valid for managed cluster, use data source tencentcloud_kubernetes_cluster_levels to query available levels. Available value examples L5, L20, L50, L100"
}

variable "cluster_max_pod_num" {
  type        = number
  default     = 256
  description = "The maximum number of Pods per node in the cluster. Default is 256. The minimum value is 4. When its power unequal to 2, it will round upward to the closest power of 2"
}

variable "enable_event_persistence" {
  type        = bool
  default     = false
  description = "Specify weather the Event Persistence enabled. "
}

variable "enable_cluster_audit_log" {
  type        = bool
  default     = false
  description = "Specify weather the Cluster Audit enabled. NOTE: Enable Cluster Audit will also auto install Log Agent."
}

variable "event_log_set_id" {
  type        = string
  default     = null
  description = "Specify id of existing CLS log set, or auto create a new set by leave it empty. "
}

variable "cluster_audit_log_set_id" {
  type        = string
  default     = null
  description = "Specify id of existing CLS log set, or auto create a new set by leave it empty. "
}

variable "event_log_topic_id" {
  type        = string
  default     = null
  description = "Specify id of existing CLS log topic, or auto create a new topic by leave it empty."
}

variable "cluster_audit_log_topic_id" {
  type        = string
  default     = null
  description = "Specify id of existing CLS log topic, or auto create a new topic by leave it empty. "
}

variable "cluster_service_cidr" {
  type        = string
  default     = null
  description = "A network address block of the service. Different from vpc cidr and cidr of other clusters within this vpc. Must be in 10./192.168/172.[16-31] segments."
}

variable "enhanced_monitor_service" {
  type        = bool
  default     = true
  description = "To specify whether to enable cloud monitor service."
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Indicates whether cluster deletion protection is enabled. Default is false."
}

variable "auto_upgrade_cluster_level" {
  default = false
  type = bool
  description = "Whether the cluster level auto upgraded, valid for managed cluster."
}

variable "is_non_static_ip_mode" {
  default = false
  type = bool
  description = "Indicates whether non-static ip mode is enabled. Default is false."
}

variable "node_name_type" {
  default = "lan-ip"
  description = "Node name type of Cluster, the available values include: 'lan-ip' and 'hostname', Default is 'lan-ip'"
  type = string
}

variable "cluster_deploy_type" {
  type = string
  default = "MANAGED_CLUSTER"
  description = "Deployment type of the cluster, the available values include: 'MANAGED_CLUSTER' and 'INDEPENDENT_CLUSTER'. Default is 'MANAGED_CLUSTER'."
}

variable "cluster_desc" {
  default = ""
  description = "Description of the cluster."
  type =string
}

variable "cluster_ipvs" {
  default = true
  type = bool
  description = "Indicates whether ipvs is enabled. Default is true. False means iptables is enabled."
}

variable "ignore_cluster_cidr_conflict" {
  default = false
  description = " Indicates whether to ignore the cluster cidr conflict error. Default is false."
  type = bool
}

variable "ignore_service_cidr_conflict" {
  default = false
  type = bool
  description = "Indicates whether to ignore the service cidr conflict error. Only valid in VPC-CNI mode."
}

variable "upgrade_instances_follow_cluster" {
  default = false
  description = " Indicates whether upgrade all instances when cluster_version change. Default is false."
  type = bool
}

variable "vpc_cni_type" {
  default = "tke-route-eni"
  type = string
  description = "Distinguish between shared network card multi-IP mode and independent network card mode. Fill in tke-route-eni for shared network card multi-IP mode and tke-direct-eni for independent network card mode. The default is shared network card mode. When it is necessary to turn off the vpc-cni container network capability, both eni_subnet_ids and vpc_cni_type must be set to empty."
}

variable "kube_proxy_mode" {
  default = null
  type = string
  description = "Cluster kube-proxy mode, the available values include: 'kube-proxy-bpf'. Default is not set.When set to kube-proxy-bpf, cluster version greater than 1.14 and with Tencent Linux 2.4 is required."
}

variable "runtime_version" {
  default = null
  type = string
  description = "Container Runtime version."
}

variable "labels" {
  default     = {}
  type        = map(string)
  description = "Labels of tke cluster nodes."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tagged for all associated resource of this module."
}

variable "node_pool_global_config" {
  description = "Global config effective for all node pools, see `https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_cluster#node_pool_global_config`"
  type = object({
    is_scale_in_enabled            = optional(bool) # Indicates whether to enable scale-in.
    expander                       = optional(string) # Indicates which scale-out method will be used when there are multiple scaling groups. Valid values: `random` - select a random scaling group, `most-pods` - select the scaling group that can schedule the most pods, `least-waste` - select the scaling group that can ensure the fewest remaining resources after Pod scheduling.
    max_concurrent_scale_in        = optional(number) # Max concurrent scale-in volume.
    scale_in_delay                 = optional(number) # Number of minutes after cluster scale-out when the system starts judging whether to perform scale-in.
    scale_in_unneeded_time         = optional(number) # Number of consecutive minutes of idleness after which the node is subject to scale-in.
    scale_in_utilization_threshold = optional(number) # Percentage of node resource usage below which the node is considered to be idle.
    ignore_daemon_sets_utilization = optional(bool) # Whether to ignore DaemonSet pods by default when calculating resource usage.
    skip_nodes_with_local_storage  = optional(bool) # During scale-in, ignore nodes with local storage pods.
    skip_nodes_with_system_pods    = optional(bool) # During scale-in, ignore nodes with pods in the kube-system namespace that are not managed by DaemonSet.
  })
  default = null
}

################################################################################
# resource: tencentcloud_kubernetes_auth_attachment
################################################################################
variable "enable_pod_identity" {
  type = bool
  default = false
  description = "enable pod identity"
}

variable "use_tke_default" {
  description = "If set to `true`, the issuer and jwks_uri will be generated automatically by tke, please do not set issuer and jwks_uri."
  type        = bool
  default     = true
}

variable "issuer" {
  description = "Specify service-account-issuer. If use_tke_default is set to `true`, please do not set this field."
  type        = string
  default     = null
}

variable "jwks_uri" {
  description = "Specify service-account-jwks-uri. If use_tke_default is set to `true`, please do not set this field."
  type        = string
  default     = null
}

variable "auto_create_discovery_anonymous_auth" {
  description = "If set to `true`, the rbac rule will be created automatically which allow anonymous user to access '/.well-known/openid-configuration' and '/openid/v1/jwks'."
  type        = bool
  default     = false
}

variable "auto_create_oidc_config" {
  description = "Creating an identity provider."
  type        = bool
  default     = true
}

variable "auto_install_pod_identity_webhook_addon" {
  description = "Creating the PodIdentityWebhook component. if `auto_create_oidc_config` is true, this field must set true."
  type        = bool
  default     = null
}

################################################################################
# resource: tencentcloud_kubernetes_log_config
################################################################################
variable "enable_log_agent" {
  type        = bool
  default     = false
  description = "Specify weather the Log agent enabled. "
}

variable "kubelet_root_dir" {
  type        = string
  default     = ""
  description = "Kubelet root directory as the literal."
}

variable "cluster_type" {
  description = "The current cluster type supports tke and eks, default is tke."
  type        = string
  default     = "tke"
}

variable "log_config_name" {
  description = "Log config name."
  type        = string
  default     = null
}

variable "logset_id" {
  description = "CLS log set ID."
  type        = string
  default     = null
}

################################################################################
# resource: tencentcloud_kubernetes_health_check_policy
################################################################################
variable "health_check_policies" {
  description = "Self healing check policies, see `https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_health_check_policy`"
  type = list(object({
    name = string # Health Check Policy Name.
    rules = list(object({
      name                = string # Health check rule details.
      enabled             = bool # Enable detection of this project or not.
      auto_repair_enabled = bool # Enable repair or not.
    }))
  }))
  default = []
}