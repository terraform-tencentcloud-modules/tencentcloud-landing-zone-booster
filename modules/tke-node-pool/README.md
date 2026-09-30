# terraform-tencentcloud-tke-node-pool

Terraform module which creates and manages one or more **TKE node pools** on an **existing** TencentCloud Kubernetes Engine (TKE) cluster.

The following resources are included.

* [Kubernetes Node Pool](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_node_pool)

A node pool manages a group of worker nodes (CVM instances) for a cluster. This module does **not** create the cluster itself — you must provide the ID of a cluster that has already been provisioned. Multiple node pools can be created by passing a map to `node_pool`; each entry is iterated with `for_each` keyed by the map key.

Notes:
- If no `password` is supplied in `auto_scaling_config`, the module falls back to a randomly generated worker login password (`random_password.worker_pwd`). Make sure the `random` provider is available in your configuration.
- The `desired_capacity` and `auto_update_instance_tags` attributes are ignored during in-place updates (`lifecycle.ignore_changes`), so scaling is managed externally / via auto scaling.

## Usage

```hcl
module "tke_node_pool" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-node-pool.git"

  # ID of an existing TKE cluster
  cluster_id = "cls-xxxxxxxx"

  # VPC id of the TKE cluster
  vpc_id = "vpc-xxxxxxxx"

  # Map of node pool definitions (keyed by a unique name)
  node_pool = {
    example_np = {
      name                     = "example_np"
      min_size                 = 1
      max_size                 = 6
      desired_capacity         = 4
      enable_auto_scale        = true
      multi_zone_subnet_policy = "EQUALITY"
      retry_policy             = "INCREMENTAL_INTERVALS"
      node_os                  = "tlinux4_x86_64_public"

      subnet_ids = ["subnet-xxxxxxxx"]

      # Auto scaling / instance configuration
      auto_scaling_config = {
        instance_type         = "S5.MEDIUM2"
        system_disk_type      = "CLOUD_PREMIUM"
        system_disk_size      = 50
        security_group_ids    = ["sg-xxxxxxxx"]
        public_ip_assigned    = true
        internet_charge_type  = "TRAFFIC_POSTPAID_BY_HOUR"
        internet_max_bandwidth_out = 10
        enhanced_security_service = true
        enhanced_monitor_service  = true

        data_disk = [
          {
            disk_type            = "CLOUD_PREMIUM"
            disk_size            = 50
            delete_with_instance = false
          }
        ]
      }

      # Node taints
      taints = [
        {
          key    = "dedicated"
          value  = "gpu"
          effect = "NoSchedule"
        }
      ]

      # Node labels
      labels = {
        "env" = "prod"
      }

      # Node-level configuration
      node_config = {
        extra_args = ["root-dir=/var/lib/kubelet"]
        data_disk = [
          {
            disk_type             = "CLOUD_PREMIUM"
            disk_size             = 100
            auto_format_and_mount = true
            file_system           = "xfs"
            mount_target          = "/data"
          }
        ]
      }
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_id | ID of an existing TKE cluster where the node pools will be created. | string | n/a | yes |
| vpc_id | VPC id of the TKE cluster. | string | n/a | yes |
| node_pool | A map of node pool definitions to create. Each key is used as the `for_each` key. See `tencentcloud_kubernetes_node_pool`. | any | {} | no |

Common fields of each `node_pool` entry:

| Field | Description |
|-------|-------------|
| name | Display name of the node pool. Defaults to the map key. |
| min_size / max_size | Minimum / maximum node count. Default to `1` if the other is set. |
| desired_capacity | Desired node count. |
| enable_auto_scale | Whether to enable auto scaling. Default `true`. |
| multi_zone_subnet_policy | Multi-zone subnet policy. Default `EQUALITY`. |
| retry_policy | Retry policy when scaling fails. Default `IMMEDIATE_RETRY`. |
| subnet_ids | List of subnet ids for the node pool. |
| node_os | Node OS image. Default `tlinux4_x86_64_public`. |
| delete_keep_instance | Whether to keep CVM instances when deleting the node pool. Default `false`. |
| deletion_protection | Whether to enable deletion protection. Default `false`. |
| auto_update_instance_tags | Whether to auto update instance tags (forceNew). |
| auto_scaling_config | Instance/disk/networking configuration (see below). |
| taints | List of node taints (`key`, `value`, `effect`). |
| labels | Map of node labels. |
| annotations | List of node annotations (`name`, `value`). |
| tags | Map of resource tags. |
| node_config | Node-level configuration (`extra_args`, `data_disk`, `docker_graph_path`). |

`auto_scaling_config` nested fields:

| Field | Description |
|-------|-------------|
| instance_type | CVM instance type. |
| backup_instance_types | Backup instance types. |
| system_disk_type | System disk type. Default `CLOUD_PREMIUM`. |
| system_disk_size | System disk size (GB). Default `50`. |
| orderly_security_group_ids | Ordered security group ids. |
| key_ids | SSH key ids. |
| public_ip_assigned | Whether to assign a public IP. Default `false`. |
| internet_charge_type | Internet billing type. |
| internet_max_bandwidth_out | Max public bandwidth (Mbps). |
| bandwidth_package_id | Bandwidth package id. |
| spot_instance_type / spot_max_price | Spot instance settings. |
| instance_charge_type | Instance billing type. |
| instance_charge_type_prepaid_period / _renew_flag | Prepaid period / renew flag. |
| cam_role_name | CAM role bound to the node. |
| password | Login password. Falls back to a randomly generated one if omitted. |
| enhanced_security_service / enhanced_monitor_service | Default `true`. |
| host_name / host_name_style | Host name and style. |
| instance_name / instance_name_style | Instance name and style. |
| data_disk | List of data disks (`disk_type`, `disk_size`, `delete_with_instance`). |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-node-pool)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| tencentcloud | >= 1.81.145 |
