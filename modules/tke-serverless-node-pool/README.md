# terraform-tencentcloud-tke-serverless-node-pool

Terraform module which creates and manages one or more **TKE serverless (SuperNode) node pools** on an **existing** TencentCloud Kubernetes Engine (TKE) cluster.

The following resources are included.

* [Kubernetes Serverless Node Pool](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_serverless_node_pool)

A serverless node pool (SuperNode pool) provides fast and efficient elasticity — you only need to care about the subnet and security group instead of the complicated node configuration. This module does **not** create the cluster itself — you must provide the ID of a cluster that has already been provisioned. Multiple serverless node pools can be created by passing a list to `serverless_node_pool`; each entry is iterated with `for_each` keyed by `name`.

The module ships with a built-in input validation:
- `taints.effect` must be one of `NoSchedule`, `PreferNoSchedule`, `NoExecute`.

## Usage

```hcl
module "tke_serverless_node_pool" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-serverless-node-pool.git"

  # ID of an existing TKE cluster
  cluster_id = "cls-xxxxxxxx"

  serverless_node_pool = [
    {
      # Name of the serverless node pool
      name = "example_serverless_np"

      # Security groups for the serverless node pool
      security_group_ids = ["sg-xxxxxxxx"]

      # Nodes in the pool (only subnet is required)
      serverless_nodes = [
        {
          display_name = "serverless_node1"
          subnet_id    = "subnet-xxxxxxxx"
        },
        {
          display_name = "serverless_node2"
          subnet_id    = "subnet-xxxxxxxx"
        }
      ]

      # Optional labels
      labels = {
        "env" = "prod"
      }

      # Optional taints
      taints = [
        {
          key    = "dedicated"
          value  = "gpu"
          effect = "NoSchedule"
        }
      ]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_id | ID of an existing TKE cluster where the serverless node pools will be created. | string | n/a | yes |
| serverless_node_pool | A list of serverless node pool definitions to create. See `tencentcloud_kubernetes_serverless_node_pool`. | list(object({...})) | [] | no |

Each item in `serverless_node_pool` supports the following schema:

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| name | string | n/a | Name of the serverless node pool (used as the `for_each` key). |
| serverless_nodes | list(object({ display_name = optional(string), subnet_id = string })) | n/a | List of serverless nodes. Only `subnet_id` is required per node. |
| security_group_ids | list(string) | null | Security groups of the serverless node pool. |
| labels | map(string) | null | Labels of the serverless nodes. |
| taints | list(object({ key = string, value = string, effect = string })) | [] | Taints of the serverless nodes. `effect` ∈ {NoSchedule, PreferNoSchedule, NoExecute}. |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-serverless-node-pool)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| tencentcloud | >= 1.81.145 |
