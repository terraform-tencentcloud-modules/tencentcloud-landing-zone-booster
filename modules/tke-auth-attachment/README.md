## terraform-tencentcloud-tke-authz-attachment

Terraform module which manages the **authentication options** (service account issuer / JWKS and OIDC identity provider) of an **existing** TencentCloud Kubernetes Engine (TKE) cluster.

The following resources are included.

* [Kubernetes Auth Attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_auth_attachment)

This module configures the cluster's authentication options (service-account issuer, JWKS URI and OIDC identity provider settings). It does **not** create the cluster itself — you must provide the ID of a cluster that has already been provisioned.

> Note: `use_tke_default`, `issuer` and `jwks_uri` are mutually exclusive in intent. When `use_tke_default` is set to `true`, do **not** set `issuer` and `jwks_uri`. When `auto_create_oidc_config` is set to `true`, `auto_install_pod_identity_webhook_addon` must be set to `true` as well.

## Usage

```hcl
module "tke_authz_attachment" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-authz-attachment.git"

  # ID of an existing TKE cluster
  cluster_id = "cls-xxxxxxxx"

  # Option A: use TKE default service-account issuer / jwks_uri
  use_tke_default = true

  # Option B: specify a custom OIDC issuer / jwks_uri
  # issuer   = "https://sts.example.com/oidc"
  # jwks_uri = "https://sts.example.com/oidc/keys"

  # Allow anonymous access to the OIDC discovery endpoints
  auto_create_discovery_anonymous_auth = true

  # Create an OIDC identity provider and install the PodIdentityWebhook
  auto_create_oidc_config                = true
  auto_create_client_id                  = ["sts.example.com"]
  auto_install_pod_identity_webhook_addon = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_id | ID of the TKE cluster to attach the authentication options to. | string | n/a | yes |
| use_tke_default | If set to `true`, the `issuer` and `jwks_uri` will be generated automatically by TKE. Do not set `issuer` and `jwks_uri` at the same time. | bool | null | no |
| issuer | Specify service-account-issuer. If `use_tke_default` is set to `true`, do not set this field. | string | null | no |
| jwks_uri | Specify service-account-jwks-uri. If `use_tke_default` is set to `true`, do not set this field. | string | null | no |
| auto_create_discovery_anonymous_auth | If set to `true`, the rbac rule will be created automatically which allows anonymous user to access `/.well-known/openid-configuration` and `/openid/v1/jwks`. | bool | false | no |
| auto_create_oidc_config | Creating an identity provider (OIDC config). | bool | null | no |
| auto_create_client_id | Creating ClientId list of the identity provider (OIDC config). | list(string) | [] | no |
| auto_install_pod_identity_webhook_addon | Creating the PodIdentityWebhook component. If `auto_create_oidc_config` is true, this field must be set to true. | bool | null | no |

## Outputs

| Name | Description |
|:---:|:---|
| tke_default_issuer | The default issuer of TKE when `use_tke_default` is true. |
| tke_default_jwks_uri | The default jwks_uri of TKE when `use_tke_default` is true. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-authz-attachment)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2 |
| tencentcloud | >= 1.83.41 |
