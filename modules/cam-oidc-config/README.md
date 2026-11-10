## terraform-tencentcloud-cam-oidc-config

Terraform module which **queries** (data source) a CAM OIDC identity provider config of TencentCloud.

The following data sources are included.

* [CAM OIDC Config](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/data-sources/cam_oidc_config)

This module reads the existing OIDC identity provider (Role IdP) configuration by its `name`. It does **not** create or modify any resource.

## Usage

```hcl
module "cam_oidc_config" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cam-oidc-config.git"

  # Name of the OIDC identity provider config
  name = "my-oidc-idp"

  # (Optional) Save the query results to a local file
  # result_output_file = "oidc_config.json"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the OIDC identity provider config to query. | string | n/a | yes |
| result_output_file | Used to save the query results to a local file. | string | null | no |

## Outputs

| Name | Description |
|:---:|:---|
| provider_type | IdP type. 11: Role IdP. |
| identity_url | IdP URL. |
| identity_key | Public key for signature. |
| client_id | Client ID. |
| status | Status. 0: Not set; 2: Disabled; 11: Enabled. |
| description | Description. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cam-oidc-config)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6 |
| tencentcloud | >= 1.81.136 |
