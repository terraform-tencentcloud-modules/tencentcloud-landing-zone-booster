# terraform-tencentcloud-ccn-accept-attach
Terraform module which accepts CCN attachment requests from network instances on TencentCloud.

This module uses the `tencentcloud_ccn_instances_accept_attach` resource to **accept** the attachment of network instances (VPC, BMVPC, VPNGW, DIRECTCONNECT) to a specified CCN instance.

## Usage

```hcl
module "ccn_accept_attach" {
  source = "terraform-tencentcloud-modules/ccn-accept-attach/tencentcloud"

  # Identify the target CCN instance (by ID or by name)
  ccn_id   = "ccn-xxxxxxxx"
  ccn_name = "ccn_test"

  # Network instances whose attachment requests will be accepted
  accept_attach_instances = [
    {
      instance_id     = "vpc-abc123"
      instance_region = "ap-guangzhou"
      instance_type   = "VPC"
      description      = "accept vpc attachment"
    },
    {
      instance_id     = "dcx-abc123"
      instance_region = "ap-shanghai"
      instance_type   = "DIRECTCONNECT"
    }
  ]
}
```

> **Note**: `ccn_id` and `ccn_name` are mutually alternative. If `ccn_id` is not set, the module looks up the CCN instance by `ccn_name`.

## Examples

- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-ccn-accept-attach/tree/master/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.136 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.136 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_ccn_instances_accept_attach.accept](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/ccn_instances_accept_attach) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ccn_id"></a> [ccn\_id](#input\_ccn\_id) | The ID of the CCN instance to which network instances will be attached. If empty and `ccn_name` is set, the CCN is looked up by name. | `string` | `""` | no |
| <a name="input_ccn_name"></a> [ccn\_name](#input\_ccn\_name) | The name of the CCN instance used to look up the CCN when `ccn_id` is empty. | `string` | `""` | no |
| <a name="input_accept_attach_instances"></a> [accept\_attach\_instances](#input\_accept\_attach\_instances) | List of network instances whose CCN attachment requests will be accepted. | `list(object({ instance_id = string, instance_region = string, instance_type = string, description = optional(string), route_table_id = optional(string) }))` | `[]` | no |

### `accept_attach_instances` object fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `instance_id` | `string` | **yes** | Attachment instance ID (e.g. VPC ID, Direct Connect ID). |
| `instance_region` | `string` | **yes** | Region where the instance is located. |
| `instance_type` | `string` | **yes** | Instance type to attach: `VPC`, `DIRECTCONNECT`, `BMVPC`, `VPNGW`. |
| `description` | `string` | no | Description of the attachment. |
| `route_table_id` | `string` | no | ID of the routing table associated with the instance. May be null. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attached_instance"></a> [attached\_instance](#output\_attached\_instance) | Classified accepted instance IDs, includes `vpc_ids`, `bmvpc_ids`, `vpngw_ids`, `directconnect_ids`. |
<!-- END_TF_DOCS -->

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
