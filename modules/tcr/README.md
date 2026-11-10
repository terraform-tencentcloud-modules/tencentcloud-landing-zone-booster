# TCR (Tencent Container Registry) Terraform Module

This module provisions a **Tencent Container Registry (TCR) instance** (`tencentcloud_tcr_instance`) along with its namespaces, repositories, service accounts, and optional VPC attachments and SSM credential storage.

Key capabilities:

- **Registry instance** — configurable type (`basic` / `standard` / `premium`), billing (postpaid / prepaid), public network access, and a public-network security allowlist.
- **VPC attachment** — optional, attaches the registry to one or more VPC/subnet pairs (`tencentcloud_tcr_vpc_attachment`), each with public/VPC domain DNS toggles.
- **Namespaces** — create one or more namespaces (`tencentcloud_tcr_namespace`) with auto-scan, public, and vulnerability-prevention flags.
- **Repositories** — create repositories (`tencentcloud_tcr_repository`) under a namespace. A `time_sleep` of 90s waits after namespaces are created to avoid race conditions.
- **Service accounts** — create service accounts (`tencentcloud_tcr_service_account`) with per-namespace permissions (`permission_type` `1` = read/write, `0` = read-only). A custom or auto-generated password is supported.
- **SSM secrets** — optionally stores each service account's credentials in Tencent Cloud SSM (`tencentcloud_ssm_secret`), controlled by `store_credentials_in_ssm`.
- **CAM role** — optionally creates the TCR service-linked role (`TCR_QCSRole`) with the `QcloudAccessForTCRRole` and `QcloudAccessForTCRRoleInSSL` policies, controlled by `create_cam_strategy`. The instance `depends_on` these role attachments.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6 |
| tencentcloud | >= 1.81.136 |
| random | >= 3.0 |

## Providers

| Provider | Source |
|----------|--------|
| tencentcloud | tencentcloudstack/tencentcloud |
| random | hashicorp/random |

## Resources

| Name | Type |
|------|------|
| `tencentcloud_tcr_instance.registry` | resource |
| `tencentcloud_tcr_vpc_attachment.vpc_attachmen` | resource (for_each over `vpc_subnet_pairs`) |
| `tencentcloud_tcr_namespace.namespace` | resource (for_each over `tcr_namespaces`) |
| `tencentcloud_tcr_repository.repository` | resource (for_each over `tcr_repositories`) |
| `tencentcloud_tcr_service_account.service_acount` | resource (for_each over `tcr_service_accounts`) |
| `tencentcloud_ssm_secret.service_account_creds` | resource (for_each, when `store_credentials_in_ssm`) |
| `tencentcloud_ssm_secret_version.service_account_creds_version` | resource (secret version `v1`) |
| `time_sleep.wait_minutes` | resource (90s wait after namespaces) |
| `tencentcloud_cam_role.tcr_qcs_role` | resource (count = 1 when `create_cam_strategy`) |
| `tencentcloud_cam_role_policy_attachment.attachment_tcr` | resource (TCR role policy) |
| `tencentcloud_cam_role_policy_attachment.attachment_tcr_in_ssl` | resource (TCR SSL role policy) |
| `data.tencentcloud_cam_policies.tcr` | data source |
| `data.tencentcloud_cam_policies.tcr_in_ssl` | data source |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | `object` | yes | – | Configuration for the TCR instance. |
| <a name="input_vpc_attachment_config"></a> [vpc\_attachment\_config](#input\_vpc\_attachment\_config) | `object` | no | `{}` | Configuration for VPC attachment. |
| <a name="input_tcr_namespaces"></a> [tcr\_namespaces](#input\_tcr\_namespaces) | `set(object)` | no | `[]` | TCR namespace configuration list. |
| <a name="input_tcr_repositories"></a> [tcr\_repositories](#input\_tcr\_repositories) | `set(object)` | no | `[]` | TCR container repository list. |
| <a name="input_tcr_service_accounts"></a> [tcr\_service\_accounts](#input\_tcr\_service\_accounts) | `set(object)` | no | `[]` | TCR service account configuration list. |
| <a name="input_create_cam_strategy"></a> [create\_cam\_strategy](#input\_create\_cam\_strategy) | `bool` | no | `false` | Whether to create the TCR CAM role and policies (set false if already enabled via console). |
| <a name="input_store_credentials_in_ssm"></a> [store\_credentials\_in\_ssm](#input\_store\_credentials\_in\_ssm) | `bool` | no | `false` | Whether to store service account credentials in SSM. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | no | `{}` | Tags to apply to all resources. |

### `instance_config` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Name of the TCR instance. |
| `type` | `string` | no | `"basic"` | TCR type: `basic`, `standard`, `premium`. |
| `delete_bucket` | `bool` | no | `false` | Whether to delete the auto-created COS bucket with the instance. |
| `enable_internet_access` | `bool` | no | `false` | Enable public network access. |
| `charge_type` | `number` | no | `1` | `1`: postpaid, `2`: prepaid. |
| `prepaid_period` | `number` | no | `1` | Prepaid period in months (1–12). Only for prepaid. |
| `prepaid_renew_flag` | `number` | no | `2` | `1`: manual, `2`: auto renew, `3`: no renew. Only for prepaid. |
| `security_policies` | `list(object)` | no | `[]` | Public network allowlist policies. Each: `cidr_block` (optional string), `description` (optional string). |

### `vpc_attachment_config` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `region` | `string` | no | `"ap-jakarta"` | Region for VPC attachment. |
| `vpc_subnet_pairs` | `list(object)` | no | `[]` | List of VPC/subnet pairs to attach. Each: `vpc_id` (string), `subnet_id` (string), `enable_public_domain_dns` (bool, default `true`), `enable_vpc_domain_dns` (bool, default `true`). |

### `tcr_namespaces` set element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | `string` | yes | – | Namespace name. |
| `is_auto_scan` | `bool` | no | `true` | Auto scan images for vulnerabilities. |
| `is_public` | `bool` | no | `false` | Make namespace publicly accessible. |
| `is_prevent_vul` | `bool` | no | `true` | Block vulnerable image deployment. |
| `severity` | `string` | no | – | Vulnerability severity: `low`, `medium`, `high`. |

### `tcr_repositories` set element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `namespace_name` | `string` | yes | – | Namespace name. |
| `repository_name` | `string` | yes | – | Repository name. |
| `brief_desc` | `string` | no | – | Brief description. |
| `description` | `string` | no | – | Detailed description. |

### `tcr_service_accounts` set element

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `account_name` | `string` | yes | – | Service account name. |
| `description` | `string` | no | – | Account description. |
| `disable` | `bool` | no | `false` | Disable the account. |
| `duration` | `number` | no | – | Token validity duration in seconds. |
| `expires_at` | `number` | no | – | Service account expiration time (timestamp, ms). |
| `password` | `string` | no | `""` | Custom password; if empty, a random password is generated. |
| `password_length` | `number` | no | `32` | Random password length. |
| `permissions` | `list(object)` | yes | – | Permission list. Each: `namespace` (string), `permission_type` (number, default `1` — `1`: read/write, `0`: read-only). |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tcr_instance_id"></a> [tcr\_instance\_id](#output\_tcr\_instance\_id) | ID of the TCR instance. |
| <a name="output_tcr_namespace_ids"></a> [tcr\_namespace\_ids](#output\_tcr\_namespace\_ids) | List of namespace IDs. |
| <a name="output_tcr_repository_ids"></a> [tcr\_repository\_ids](#output\_tcr\_repository\_ids) | List of repository IDs. |
| <a name="output_tcr_service_account_password"></a> [tcr\_service\_account\_password](#output\_tcr\_service\_account\_password) | List of service account passwords (sensitive). |

## Usage

```hcl
module "tcr" {
  source = "./modules/tcr"

  tags = {
    env = "prod"
  }

  create_cam_strategy      = true
  store_credentials_in_ssm = true

  instance_config = {
    name                   = "my-registry"
    type                   = "standard"
    delete_bucket          = false
    enable_internet_access = false
    charge_type            = 1
    security_policies = [
      {
        cidr_block  = "10.0.0.0/16"
        description = "Internal VPC access"
      }
    ]
  }

  vpc_attachment_config = {
    region = "ap-jakarta"
    vpc_subnet_pairs = [
      {
        vpc_id                   = "vpc-xxxxxxxx"
        subnet_id                = "subnet-xxxxxxxx"
        enable_public_domain_dns = true
        enable_vpc_domain_dns    = true
      }
    ]
  }

  tcr_namespaces = [
    {
      name           = "app"
      is_auto_scan   = true
      is_public      = false
      is_prevent_vul = true
    }
  ]

  tcr_repositories = [
    {
      namespace_name  = "app"
      repository_name = "web"
      brief_desc      = "Web service images"
    }
  ]

  tcr_service_accounts = [
    {
      account_name = "ci-robot"
      description  = "CI push account"
      permissions = [
        {
          namespace       = "app"
          permission_type = 1
        }
      ]
    }
  ]
}
```

> **Notes**:
> - Repositories are created after a 90s wait (`time_sleep`) following namespace creation to avoid dependency races.
> - When `create_cam_strategy = false`, ensure the `TCR_QCSRole` role with `QcloudAccessForTCRRole` / `QcloudAccessForTCRRoleInSSL` policies is already enabled via the console, otherwise instance creation may fail.
> - Service account passwords are marked sensitive; when `store_credentials_in_ssm = true`, credentials are stored as SSM secrets named `tcr-<instance>-sa-<account>-secret`.
