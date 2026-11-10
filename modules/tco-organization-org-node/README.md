# terraform-tencentcloud-tco-organization-org-node

Terraform module which creates Organization nodes (departments) on TencentCloud.

The following resources are included.

* [Organization Org Node](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/organization_org_node)

It also reads the existing organization nodes via the `tencentcloud_organization_nodes` data source to resolve the root node ID.

## Usage

```hcl
variable "org_nodes" {
  type = map(object({
    parent_id = optional(number, null) # Parent node ID. If null or 0, the root node is used.
    name      = string                 # Node name.
    remark    = optional(string)       # Node remark.
  }))
  default = {
    dept1 = {
      parent_id = null
      name      = "Engineering"
      remark    = "Engineering department"
    }
  }
}

module "organization_org_node" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-node.git"

  org_nodes = var.org_nodes
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| org_nodes | A map of organization nodes starting from the root. Each item contains: optional `parent_id` (parent node ID; null or 0 means root), `name` (node name), optional `remark`. | map(object({ parent_id = optional(number, null), name = string, remark = optional(string) })) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| node_ids | A map of node keys to the created organization node IDs. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tco-organization-org-node)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
