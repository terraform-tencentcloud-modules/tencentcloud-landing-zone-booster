# TKE Authorization (tke-authz) Terraform Module

This module manages **TKE cluster authorization** (`tencentcloud_kubernetes_user_permissions`) — granting CAM users or roles permissions on one or more TKE clusters via predefined or custom RBAC roles.

Key capabilities:

- **User & role authorization** — grant TKE permissions to CAM users (`target_type = "user"`) or CAM roles (`target_type = "role"`).
- **Flexible target resolution** — for each authorization entry you may specify the target directly by `target_uin`, or by `target_name` + `target_type` (the module queries CAM to resolve the UIN/role ID automatically via `tencentcloud_cam_users` / `tencentcloud_cam_role_detail` data sources).
- **Per-permission cluster binding** — each permission entry maps to a `ClusterRoleBinding` (cluster-level) or `RoleBinding` (namespace-level), with support for predefined roles (`tke:admin`, `tke:ops`, `tke:dev`, `tke:ro`, `tke:ns:dev`, `tke:ns:ro`) and custom roles.
- **Default cluster fallback** — when `default_cluster_id` is set, individual permission items may omit `cluster_id`.
- **Built-in validations** — three `validation` blocks enforce: required `cluster_id` when no default is provided, at least one of `target_uin`/`target_name`, and a valid `target_type` of `user`/`role`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2 |
| tencentcloud | >= 1.81.136 |

## Providers

| Provider | Source |
|----------|--------|
| tencentcloud | tencentcloudstack/tencentcloud |

## Resources

| Name | Type |
|------|------|
| `tencentcloud_kubernetes_user_permissions.authz` | resource (for_each over `authz_permissions`) |
| `data.tencentcloud_cam_users.users` | data source (for `target_type = "user"`) |
| `data.tencentcloud_cam_role_detail.roles` | data source (for `target_type = "role"`) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_default_cluster_id"></a> [default\_cluster\_id](#input\_default\_cluster\_id) | `string` | no | `null` | Default TKE cluster ID, used when a permission item does not specify `cluster_id`. |
| <a name="input_authz_permissions"></a> [authz\_permissions](#input\_authz\_permissions) | `map(object)` | no | – | User authorization settings and the complete list of TKE permissions. Keyed by a unique identifier per entry. |

### `authz_permissions` element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `target_uin` | `string` | no | – | CAM user UIN or role UIN. Takes precedence over `target_name` if provided. |
| `target_name` | `string` | no | – | CAM user name or role name (resolved to a UIN/role ID via data source lookup). |
| `target_type` | `string` | no* | – | Target type: `user` (CAM user) or `role` (CAM role). Required when `target_uin` is not set. |
| `permissions` | `list(object)` | no | `[]` | List of TKE permission bindings. See element structure below. |

> \* `target_type` must be a non-empty value of `user`/`role` when `target_uin` is not provided. Each entry must specify at least one of `target_uin` or `target_name`.

#### `permissions` element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `cluster_id` | `string` | no* | – | Target cluster ID. Falls back to `default_cluster_id` when omitted. Required when `default_cluster_id` is `null`. |
| `role_name` | `string` | yes | – | RBAC role name. Predefined: `tke:admin` (cluster admin), `tke:ops` (ops), `tke:dev` (developer), `tke:ro` (read-only), `tke:ns:dev` (namespace developer), `tke:ns:ro` (namespace read-only); other values are custom roles. |
| `role_type` | `string` | yes | – | Permission scope: `cluster` (ClusterRoleBinding) or `namespace` (RoleBinding). |
| `is_custom` | `bool` | no | `false` | Whether the role is a custom role. |
| `namespace` | `string` | no | – | Target namespace (required when `role_type = "namespace"`). |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the resource (`tencentcloud_kubernetes_user_permissions.authz[0].id`; null if no entries). |

## Usage

### Authorize by UIN with a default cluster

```hcl
module "tke_authz" {
  source = "./modules/tke-authz"

  default_cluster_id = "cls-xxxxxxxx"

  authz_permissions = {
    "alice" = {
      target_uin  = "100000000001"
      target_type = "user"
      permissions = [
        {
          role_name = "tke:admin"
          role_type = "cluster"
          is_custom = false
        }
      ]
    }
    "bob-dev" = {
      target_uin  = "100000000002"
      target_type = "user"
      permissions = [
        {
          role_name = "tke:ns:dev"
          role_type = "namespace"
          namespace = "app-team"
        }
      ]
    }
  }
}
```

### Authorize by name (auto-resolve UIN) for a user and a role

```hcl
module "tke_authz" {
  source = "./modules/tke-authz"

  authz_permissions = {
    "ci-robot" = {
      target_name = "ci-robot"
      target_type = "user"
      permissions = [
        {
          cluster_id = "cls-xxxxxxxx"
          role_name  = "tke:ro"
          role_type  = "cluster"
        }
      ]
    }
    "deploy-role" = {
      target_name = "TKEDeployRole"
      target_type = "role"
      permissions = [
        {
          cluster_id = "cls-xxxxxxxx"
          role_name  = "tke:ops"
          role_type  = "cluster"
        }
      ]
    }
  }
}
```

> **Notes**:
> - When `target_uin` is set it is used directly; otherwise the module resolves the UIN/role ID by querying CAM with `target_name` + `target_type`.
> - When `default_cluster_id` is `null`, every permission entry must specify its own `cluster_id` (enforced by a `validation` block).
> - `target_type` must be `user` or `role` whenever `target_uin` is not provided; each entry needs at least one of `target_uin` / `target_name`.
> - The resource is created per entry via `for_each`; the `id` output returns the first entry's ID (or `null` if the map is empty).
