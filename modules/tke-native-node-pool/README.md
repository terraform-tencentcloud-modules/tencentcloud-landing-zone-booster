# terraform-tencentcloud-tke-native-node-pool

Terraform module which creates and manages one or more **TKE Native node pools** on an **existing** TencentCloud Kubernetes Engine (TKE) cluster.

The following resources are included.

* [Kubernetes Native Node Pool](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_native_node_pool)

A Native node pool manages regular CVM-based worker nodes. This module does **not** create the cluster itself — you must provide the ID of a cluster that has already been provisioned. Multiple node pools can be created by passing a list to `native_node_pools`; each entry is iterated with `for_each` keyed by `name`.

The module ships with a set of built-in input validations to catch misconfiguration early, including:
- `taints.effect` must be one of `NoSchedule`, `PreferNoSchedule`, `NoExecute`.
- `instance_charge_type` must be `PREPAID` or `POSTPAID_BY_HOUR` (default `POSTPAID_BY_HOUR`).
- `system_disk.disk_type` must be `CLOUD_PREMIUM`, `CLOUD_SSD`, `CLOUD_BSSD` or `CLOUD_HSSD`.
- `instance_charge_prepaid` is required when `instance_charge_type` is `PREPAID`.
- `scaling.create_policy` must be `ZoneEquality` or `ZonePriority`.
- `instance_charge_prepaid.period` / `renew_flag` are validated against the allowed enum values.
- `internet_accessible.charge_type` must be `TRAFFIC_POSTPAID_BY_HOUR`, `BANDWIDTH_POSTPAID_BY_HOUR` or `BANDWIDTH_PACKAGE`, and `bandwidth_package_id` is required when `charge_type` is `BANDWIDTH_PACKAGE`.
- `data_disks.disk_type` must be one of `CLOUD_PREMIUM`, `CLOUD_SSD`, `CLOUD_BSSD`, `CLOUD_HSSD`, `CLOUD_TSSD`, `LOCAL_NVME`.

## Usage

```hcl
module "tke_native_node_pool" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-native-node-pool.git"

  # ID of an existing TKE cluster
  cluster_id = "cls-xxxxxxxx"

  native_node_pools = [
    {
      # Node pool name (also used as the for_each key)
      name                = "example-native-np"
      deletion_protection = false
      unschedulable       = false

      # Networking & instance spec
      subnet_ids         = ["subnet-xxxxxxxx"]
      instance_types     = ["S5.MEDIUM2"]
      security_group_ids = ["sg-xxxxxxxx"]

      # Billing & machine type
      instance_charge_type = "POSTPAID_BY_HOUR"
      machine_type         = "Native"
      auto_repair          = true
      enable_autoscaling   = true
      replicas             = 3

      # System disk (required)
      system_disk = {
        disk_type = "CLOUD_PREMIUM"
        disk_size = 50
      }

      # Optional data disks
      data_disks = [
        {
          disk_type             = "CLOUD_PREMIUM"
          disk_size             = 100
          auto_format_and_mount = true
          file_system           = "ext4"
          mount_target          = "/data"
        }
      ]

      # Optional autoscaling range
      scaling = {
        min_replicas  = 1
        max_replicas  = 6
        create_policy = "ZoneEquality"
      }

      # Optional public network bandwidth
      internet_accessible = {
        charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
        max_bandwidth_out = 10
      }

      # Optional node labels & taints
      labels = [
        { name = "env", value = "prod" }
      ]
      taints = [
        { key = "dedicated", value = "gpu", effect = "NoSchedule" }
      ]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_id | ID of an existing TKE cluster where the native node pools will be created. | string | n/a | yes |
| native_node_pools | A list of native node pool definitions to create. See `tencentcloud_kubernetes_native_node_pool`. | list(object({...})) | [] | no |

Each item in `native_node_pools` supports the following schema:

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| name | string | n/a | Node pool name (used as the `for_each` key). |
| deletion_protection | bool | null | Whether to enable deletion protection. |
| unschedulable | bool | null | Whether the node is unschedulable by default. |
| labels | list(object({name, value})) | [] | Node labels. |
| taints | list(object({key, value, effect})) | [] | Node taints. `effect` ∈ {NoSchedule, PreferNoSchedule, NoExecute}. |
| tags | list(object({resource_type, tags})) | [] | Node tags. `resource_type` ∈ {cluster, machine}. |
| annotations | list(object({name, value})) | [] | Node annotations. |
| subnet_ids | list(string) | n/a | Subnet list. |
| instance_types | list(string) | n/a | Instance model list. |
| security_group_ids | list(string) | n/a | Security group list. |
| instance_charge_type | string | POSTPAID_BY_HOUR | Billing type: `PREPAID` or `POSTPAID_BY_HOUR`. |
| machine_type | string | Native | Node pool type: `NativeCVM` or `Native`. |
| auto_repair | bool | null | Whether to enable self-healing. |
| enable_autoscaling | bool | null | Whether to enable elastic scaling. |
| replicas | number | null | Desired number of nodes. |
| health_check_policy_name | string | null | Fault self-healing rule name. |
| host_name_pattern | string | null | Host name pattern string. |
| kubelet_args | list(string) | null | Kubelet custom parameters. |
| runtime_root_dir | string | null | Runtime root directory. |
| key_ids | list(string) | null | SSH public key id array. |
| scaling | object({min_replicas, max_replicas, create_policy}) | null | Autoscaling configuration. |
| system_disk | object({disk_type, disk_size}) | n/a | System disk config. `disk_type` ∈ {CLOUD_PREMIUM, CLOUD_SSD, CLOUD_BSSD, CLOUD_HSSD}. |
| instance_charge_prepaid | object({period, renew_flag}) | null | Prepaid billing config (required when `instance_charge_type = PREPAID`). |
| management | object({nameservers, hosts, kernel_args}) | null | Management parameter settings. |
| lifecycle | object({pre_init, post_init}) | null | Pre/post init custom scripts. |
| internet_accessible | object({charge_type, max_bandwidth_out, bandwidth_package_id}) | null | Public network bandwidth config. |
| data_disks | list(object({disk_type, disk_size, auto_format_and_mount, ...})) | [] | Data disk list. |

## Outputs

| Name | Description |
|:---:|:---|
| node_pool_ids | Map of node pool name to its id. |
| node_pool_names | Map of node pool name to its display name. |
| node_pools | Map of node pool name to its full attributes. |
| autoscaling_config | Map of node pool name to its autoscaling configuration (null if scaling is not set). |
| node_pool_nodes | Map of node pool name to its node (machine) details. |
| node_instance_ids | Map of node pool name to the list of node instance ids. |
| node_private_ips | Map of node pool name to the list of node private ips. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-native-node-pool)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| tencentcloud | >= 1.81.145 |
