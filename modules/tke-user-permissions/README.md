## terraform-tencentcloud-tke-user-permissions

Terraform module which manages **user / role authorization (RBAC permissions)** for one or more TencentCloud Kubernetes Engine (TKE) clusters.

The following resources are included.

* [Kubernetes User Permissions](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_user_permissions)

This module assigns cluster-level or namespace-level RBAC roles to CAM users or CAM roles. For each authorization entry you can either provide the target `target_uin` directly, or provide `target_name` together with `target_type` (`user` or `role`) and the module will look up the corresponding UIN / role ID automatically.

### How target_uin is resolved

* If `target_uin` is provided, it is used directly.
* If `target_uin` is empty:
  * `target_type = "user"` → the module queries `tencentcloud_cam_users` by `target_name` and uses the resolved `uin`.
  * `target_type = "role"` → the module queries `tencentcloud_cam_role_detail` by `target_name` and uses the resolved `role_id`.

### Validation rules (enforced by the module)

* When `default_cluster_id` is not set, every permission item **must** specify a non-empty `cluster_id`.
* `target_uin` and `target_name` cannot both be empty for any entry.
* `target_type` must be non-empty and one of: `user`, `role`.

## Usage

```hcl
module "tke_user_permissions" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-user-permissions.git"

  # Optional default cluster id used when a permission item omits cluster_id
  default_cluster_id = "cls-xxxxxxxx"

  authz_permissions = {
    "alice" = {
      target_type = "user"
      target_name = "alice" # CAM user name; module resolves the UIN automatically

      permissions = [
        {
          role_name = "tke:admin" # cluster administrator
          role_type = "cluster"
          is_custom = false
        }
      ]
    }

    "ci-role" = {
      target_type = "role"
      target_name = "ci-role" # CAM role name; module resolves the role ID automatically

      permissions = [
        {
          cluster_id = "cls-yyyyyyyy" # overrides default_cluster_id
          role_name  = "tke:ns:dev"   # namespace developer
          role_type  = "namespace"
          is_custom  = false
          namespace  = "team-a"
        }
      ]
    }

    "bob" = {
      target_uin  = "100000000001" # provide UIN directly, skip name lookup
      target_type = "user"

      permissions = [
        {
          role_name = "tke:ro" # read-only user
          role_type = "cluster"
          is_custom = false
        }
      ]
    }
  }
}
```

### Predefined role names (`role_name`)

Predefined roles include:

* `tke:admin` — cluster administrator
* `tke:ops` — operations personnel
* `tke:dev` — developer
* `tke:ro` — read-only user
* `tke:ns:dev` — namespace developer
* `tke:ns:ro` — namespace read-only user

Other values are user-defined roles.

### `role_type` enum

* `cluster` — cluster-level permissions (corresponds to `ClusterRoleBinding`)
* `namespace` — namespace-level permissions (corresponds to `RoleBinding`)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default_cluster_id | Default TKE cluster ID. Used when a permission item does not specify `cluster_id`. | string | null | no |
| authz_permissions | User authorization settings and the complete list of TKE permissions. | map(object({ target_uin = optional(string), target_name = optional(string), target_type = optional(string), permissions = optional(list(object({ cluster_id = optional(string), role_name = string, role_type = string, is_custom = optional(bool, false), namespace = optional(string) })), []) })) | n/a | yes |

#### `authz_permissions` object fields

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| target_uin | Optional CAM user UIN or role UIN. If set, it is used directly and name lookup is skipped. | string | null |
| target_name | Optional CAM user name or role name. Used together with `target_type` to resolve the UIN / role ID. | string | null |
| target_type | Enum values: `user` (CAM user), `role` (CAM role). Required (and must be `user` or `role`) when `target_uin` is empty. | string | null |
| permissions | List of RBAC permission items for the target. | list(object) | [] |

##### `permissions` item fields

| Field | Description | Type | Default |
|-------|-------------|------|---------|
| cluster_id | TKE cluster ID for this permission item. Required when `default_cluster_id` is not set. | string | null |
| role_name | RBAC role name. Predefined: `tke:admin`, `tke:ops`, `tke:dev`, `tke:ro`, `tke:ns:dev`, `tke:ns:ro`; others are user-defined. | string | n/a |
| role_type | Enum values: `cluster` (ClusterRoleBinding), `namespace` (RoleBinding). | string | n/a |
| is_custom | Whether the role is a custom role. | bool | false |
| namespace | Target namespace. Required for `role_type = "namespace"`. | string | null |

## Outputs

| Name | Description |
|:---:|:---|
| id | ID of the `tencentcloud_kubernetes_user_permissions` resource (first entry). |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-user-permissions)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2 |
| tencentcloud | >= 1.81.136 |
