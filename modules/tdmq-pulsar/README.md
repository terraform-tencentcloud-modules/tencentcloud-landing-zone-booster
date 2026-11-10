# terraform-tencentcloud-tdmq-pulsar
Terraform module which creates TDMQ for Pulsar (professional cluster) resources on TencentCloud.

> **Note:** `tencentcloud_tdmq_instance` is **deprecated** (its `Create` returns an error instructing to use the professional cluster). This module uses `tencentcloud_tdmq_professional_cluster` as the cluster/instance resource.

## Resources created

| Resource | Count | Notes |
|----------|-------|-------|
| `tencentcloud_tdmq_professional_cluster` | 1 | The Pulsar cluster. |
| `tencentcloud_tdmq_namespace` | 0..N | Keyed by `environ_name`. |
| `tencentcloud_tdmq_role` | 0..N | Keyed by `role_name`. |
| `tencentcloud_tdmq_topic` | 0..N | Keyed by `environ_id/topic_name`. |
| `tencentcloud_tdmq_subscription` | 0..N | Keyed by `environment_id/topic_name/subscription_name`. |
| `tencentcloud_tdmq_namespace_role_attachment` | 0..N | Keyed by `environ_id/role_name`. |

## Usage

```hcl
module "pulsar" {
  source = "../../../../tc-modules/modules/tdmq-pulsar"

  cluster = {
    cluster_name    = "boost-life-pulsar"
    zone_ids        = [200002, 200003, 200004] # 3 AZ for multi-AZ; 1 AZ for single.
    product_name    = "pulsar.2u4g"
    storage_size    = 300
    auto_renew_flag = 0
    tags            = { createdBy = "terraform" }
  }

  namespaces = [
    {
      environ_name = "dev"
      msg_ttl      = 300
      remark       = "dev namespace"
      retention_policy = {
        time_in_minutes = 60
        size_in_mb      = 1024
      }
    }
  ]

  roles = [
    { role_name = "producer", remark = "producer role" },
    { role_name = "consumer", remark = "consumer role" }
  ]

  topics = [
    {
      environ_id = "dev"
      topic_name = "orders"
      partitions = 6
      pulsar_topic_type = 3 # persistent partitioned
    }
  ]

  subscriptions = [
    {
      environment_id    = "dev"
      topic_name        = "orders"
      subscription_name = "orders-consumer"
    }
  ]

  namespace_role_attachments = [
    { environ_id = "dev", role_name = "producer", permissions = ["produce"] },
    { environ_id = "dev", role_name = "consumer", permissions = ["consume"] }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >=0.12 |
| tencentcloud | >=1.81.136 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `cluster` | TDMQ for Pulsar professional cluster configuration. | `object` (see `variables.tf`) | n/a |
| `namespaces` | List of TDMQ namespaces. | `list(object)` | `[]` |
| `roles` | List of TDMQ roles. | `list(object)` | `[]` |
| `topics` | List of TDMQ topics. | `list(object)` | `[]` |
| `subscriptions` | List of TDMQ subscriptions. | `list(object)` | `[]` |
| `namespace_role_attachments` | List of namespace-role permission attachments. | `list(object)` | `[]` |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_id` | The ID of the professional cluster. |
| `cluster_name` | The name of the professional cluster. |
| `namespace_ids` | Map of namespace name to composite ID. |
| `role_names` | Map of role key to role name. |
| `role_tokens` | Map of role key to authentication token (sensitive). |
| `topic_ids` | Map of topic key to topic ID. |
| `subscription_ids` | Map of subscription key to subscription ID. |
| `namespace_role_attachment_ids` | Map of attachment key to attachment ID. |

## Authors

Maintained by the Boost Life migration / Landing Zone team.

## License

Mozilla Public License Version 2.0.
