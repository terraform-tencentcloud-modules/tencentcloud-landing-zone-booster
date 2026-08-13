## August 13, 2026

### Summary

Added configurable server-side encryption support to the COS bucket Terraform module. Consumers can now use COS-managed encryption or a Tencent Cloud KMS key without changing the module's default behavior.

### Added

#### COS bucket server-side encryption

- Added the `encryption_algorithm` input variable.
  - Supported values: `AES256`, `KMS`, and `SM4`.
  - Defaults to `null`, preserving the existing behavior when encryption is not configured.
- Added the `kms_id` input variable.
  - Specifies the KMS master key ID when `encryption_algorithm` is set to `KMS`.
  - Defaults to `null`, allowing COS to use the default KMS key when no key ID is provided.
- Passed both encryption settings to the `tencentcloud_cos_bucket` resource.

### Usage

#### Enable AES256 encryption

```hcl
module "cos_bucket" {
  source = "..."

  bucket_name         = "example-bucket"
  encryption_algorithm = "AES256"
}
```

#### Enable KMS encryption with a specified key

```hcl
module "cos_bucket" {
  source = "..."

  bucket_name          = "example-bucket"
  encryption_algorithm = "KMS"
  kms_id               = "your-kms-key-id"
}
```

#### Enable KMS encryption with the default key

```hcl
module "cos_bucket" {
  source = "..."

  bucket_name          = "example-bucket"
  encryption_algorithm = "KMS"
}
```

### Compatibility

This change is backward compatible. Both new variables default to `null`, so existing module consumers do not need to update their configurations.

When specifying `kms_id`, `encryption_algorithm` must be set to `KMS`.

### Validation Checklist

- [ ] `terraform fmt -check` passes
- [ ] `terraform validate` passes
- [ ] Existing configurations without encryption produce no unexpected changes
- [ ] `AES256` and `SM4` encryption plans contain the expected COS settings
- [ ] KMS encryption works with both the default key and a specified `kms_id`
- [ ] The Terraform plan contains no unintended bucket replacement

### Suggested Release Title

```text
feat(cos): add server-side encryption support for COS buckets
```

### Suggested Commit Message

```text
feat(cos): add configurable server-side bucket encryption

- support AES256, KMS, and SM4 encryption algorithms
- allow specifying a KMS master key ID
- preserve existing behavior with optional encryption settings
```

## August 12, 2026

### Summary

This update improves the portability of preventive organization policies by accepting policy content directly instead of reading it from a local file. It also refreshes the delegated service assignment reference with the latest service IDs and supported services.

### Changed

#### Preventive compliance policies

- Updated `components/compliance/preventive` to accept inline policy content through `org_service_policies[*].content`.
- Replaced the local file lookup:

  ```hcl
  content = file(item.path)
  ```

  with direct content assignment:

  ```hcl
  content = item.content
  ```

- Renamed the `org_service_policies` object field from `path` to `content`.
- Removed the module's dependency on policy files being available on the local filesystem.
- Policy content can now be passed from variables, templates, remote configuration, or another Terraform module.

#### Organization service assignments

- Updated the delegated service reference in `components/organization/service-assign/variables.tf`.
- Refreshed service names and IDs:

  | Service | Previous ID | Current ID |
  |---|---:|---:|
  | WAF | 24 | 28 |
  | Cloud Security Center / CSIP | 15 | 23 |
  | Key Management Service | 25 | 29 |
  | Control Center | 17 | 24 |
  | CloudAudit | 12 | 12 |
  | Billing Center | 13 | 13 |
  | Config | 18 | 18 |

- Added references for newly supported services:
  - Quota Center (`27`)
  - Firewall Manager (`30`)
  - Identity Center Management (`25`)
- Removed obsolete references for:
  - ICP (`22`)
  - Cloud Virtual Machine (`23`)
  - Andon (`20`)

### Breaking Changes

> The preventive policy input schema has changed and requires updates in all calling configurations.

The following configuration is no longer supported:

```hcl
org_service_policies = [
  {
    name = "prevent-public-access"
    path = "${path.module}/policies/prevent-public-access.json"
    targets = []
  }
]
```

Pass the policy document through `content` instead:

```hcl
org_service_policies = [
  {
    name    = "prevent-public-access"
    content = file("${path.module}/policies/prevent-public-access.json")
    targets = []
  }
]
```

This moves file loading responsibility from the component to its caller. Existing callers using `path` will fail Terraform type validation until migrated.

### Migration Notes

1. Locate every `org_service_policies` declaration that uses `path`.
2. Rename `path` to `content`.
3. If the policy is still stored in a file, wrap the path with `file(...)` in the calling module.
4. Update any variable definitions, Terragrunt inputs, examples, and documentation that expose the old `path` field.
5. Review `service_assign_list` values and replace obsolete delegated service IDs with the current IDs.
6. Pay particular attention to ID `23`, which now refers to CSIP rather than CVM in the updated reference.
7. Run `terraform validate` and `terraform plan` before applying the changes.

### Validation Checklist

- [ ] All preventive policy callers use `content` instead of `path`
- [ ] JSON policy documents are valid before being passed to the component
- [ ] No Terragrunt or CI/CD inputs still depend on the old `path` field
- [ ] Delegated service IDs match the updated Tencent Cloud organization service catalog
- [ ] Removed service IDs are no longer used by `service_assign_list`
- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes
- [ ] `terraform plan` contains no unexpected policy replacement or service assignment changes

### Suggested Release Title

```text
feat(compliance): support inline policy content and refresh delegated service IDs
```

## August 10, 2026

### Summary

This release focuses on the **modularization of the TKE Terraform module**. It also adds support for CLB logging and free SSL certificates, while updating Terraform definitions across networking, organization, security, and foundational infrastructure modules.

- Added 8 standalone Terraform modules
- Updated 19 existing files
- Removed 28 files from the legacy monolithic TKE module and its examples
- Affected networking, organization, security, database, compute, load balancing, certificate, and container service capabilities

### Added

#### New Modules

- `modules/clb-log/`
  - Added a module for managing CLB logs.
- `modules/ssl-free-certificate/`
  - Added a module for requesting and managing free SSL certificates.
- `modules/tke-addon/`
  - Added a standalone module for managing TKE cluster add-ons.
- `modules/tke-cluster-endpoint/`
  - Added a standalone module for managing TKE cluster access endpoints.
- `modules/tke-instance/`
  - Added a module for managing TKE cluster node instances.
- `modules/tke-native-node-pool/`
  - Added a module for managing TKE native node pools.
- `modules/tke-node-pool/`
  - Added a module for managing standard TKE node pools.
- `modules/tke-serverless-node-pool/`
  - Added a module for managing TKE Serverless node pools.

### Changed

#### Networking

- Updated resource definitions and input variables for the ACL component:
  - `components/network/acl/main.tf`
  - `components/network/acl/variables.tf`
- Updated resource definitions, input variables, and outputs for the CCN-VPC component:
  - `components/network/ccn-vpc/main.tf`
  - `components/network/ccn-vpc/variables.tf`
  - `components/network/ccn-vpc/outputs.tf`
- Updated resource definitions for the NAT Gateway module:
  - `modules/nat-gateway/main.tf`

#### Organization

- Updated resource definitions and input variables for the department hierarchy component:
  - `components/organization/departments/main.tf`
  - `components/organization/departments/variables.tf`

#### Security

- Updated the Cloud Firewall VPC route reconfiguration logic:
  - `components/security/cfw/fw-vpc-route-reconfig/main.tf`
- Updated resource definitions, input variables, and outputs for the WAF component:
  - `components/security/waf/main.tf`
  - `components/security/waf/variables.tf`
  - `components/security/waf/outputs.tf`
- Updated the SSL Certificate module documentation:
  - `modules/ssl-certificate/README.md`

#### Compute and Database

- Updated resource definitions, input variables, and outputs for the CDB for MySQL instance module:
  - `modules/cdb-mysql-instance/main.tf`
  - `modules/cdb-mysql-instance/variables.tf`
  - `modules/cdb-mysql-instance/output.tf`
- Updated resource definitions, input variables, and outputs for the CVM instance module:
  - `modules/cvm-instance/main.tf`
  - `modules/cvm-instance/variables.tf`
  - `modules/cvm-instance/output.tf`

### Removed

#### Legacy TKE Module

Removed the monolithic `modules/tke/` module, including:

- Core cluster resource definitions
- CAM permission configuration
- Input variables and outputs
- Provider and version constraints
- Module documentation

#### Legacy TKE Examples

Removed examples bundled with the legacy module:

- `all-in-one`
- `kubernetes`
- `managed-node-pool`
- `new-addons`
- `pod-identity`
- `vpc-cni-cluster`

### Breaking Changes

> This TKE refactoring introduces potentially breaking changes. Consumers of the legacy `modules/tke` module cannot upgrade without migration work.

- The monolithic `modules/tke` module has been removed and must be replaced with the new standalone TKE modules.
- Variables, outputs, and Terraform resource addresses may have changed.
- Capabilities previously managed internally by the legacy module, including CAM permissions, node pools, add-ons, and cluster endpoints, may now require explicit module declarations.
- Deployment workflows based on the legacy examples must be updated to use the new module composition.
- Replacing the module source directly may cause Terraform to interpret existing resources as deleted and recreated. Review state addresses and the execution plan before upgrading.

### Migration Notes

1. Pin the current module version and back up the Terraform state before upgrading production environments.
2. Select the new TKE modules required by the existing deployment:
   - Add-ons: `tke-addon`
   - Cluster endpoints: `tke-cluster-endpoint`
   - Node instances: `tke-instance`
   - Standard node pools: `tke-node-pool`
   - Native node pools: `tke-native-node-pool`
   - Serverless node pools: `tke-serverless-node-pool`
3. Compare the variables and outputs of the old and new modules, then update all consumer references.
4. Migrate Terraform state with `moved` blocks, `terraform state mv`, or resource imports to prevent unintended recreation.
5. Run `terraform init -upgrade`, `terraform validate`, and `terraform plan`, and confirm that no unexpected deletions or replacements are proposed.
6. Pay particular attention to cluster endpoints, node pools, add-ons, networking configuration, and CAM permissions.

## March 30, 2026

- **Project initialization:** Add the first set of core **components** and supporting **modules**.
