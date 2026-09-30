# terraform-tencentcloud-tke-addon

Terraform module which enables and manages Kubernetes addons on an existing TencentCloud Kubernetes Engine (TKE) cluster.

The following resources are included.

* [Kubernetes Addon](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_addon)

This module installs the specified addons (such as monitoring, logging, or any other TKE-supported addon) into an already provisioned TKE cluster identified by `cluster_id`. It does not create the cluster itself.

## Usage

```hcl
# Assume you already have a TKE cluster provisioned and its id is available.
module "tke_addon" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-addon.git"

  # ID of an existing TKE cluster
  cluster_id = "cls-xxxxxxxx"

  # Addons to enable on the cluster
  cluster_addons = [
    {
      # Name of the addon (e.g. "tke-monitor", "tke-log-agent", "CBS", etc.)
      addon_name    = "tke-monitor"
      # Optional: leave null/empty to install the latest version by default
      addon_version = "1.0.0"
      # Optional: addon parameters in base64-encoded JSON format
      raw_values    = base64encode(jsonencode({
        # addon specific parameters
        foo = "bar"
      }))
    },
    {
      addon_name = "tke-log-agent"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_id | ID of an existing TKE cluster where the addons will be installed. | string | n/a | yes |
| cluster_addons | A list of addon configurations to enable for the cluster. Each item contains: `addon_name` (name of the addon, required), `addon_version` (optional version of the addon; if not set, the latest version is installed by default), and `raw_values` (optional addon parameters in base64-encoded JSON format). See `tencentcloud_kubernetes_addon` for details. | list(object({ addon_name = string, addon_version = optional(string), raw_values = optional(string) })) | [] | no |

## Outputs

No outputs.

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-addon)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| tencentcloud | >= 1.81.145 |
