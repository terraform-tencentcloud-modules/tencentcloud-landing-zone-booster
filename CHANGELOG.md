## August 18, 2026

### Summary

This release expands Account Factory baseline capabilities, improves organization AssumeRole identity assignments, standardizes CCN module inputs, and simplifies the VPC module to focus exclusively on VPC and subnet provisioning.

The VPC module refactoring and CCN variable renaming introduce breaking changes that require updates in consuming configurations.

### Added

#### Account notification baseline

- Added support for the `TCC-AF_ACCOUNT_NOTIFICATION` account baseline.
- Added the optional `account_message` input with the following subscription attributes:
  - `msg_type`
  - `channel`
  - `names`
- Encoded account notification subscriptions into the baseline `configuration` payload.
- Account notification configuration is included when both `account_contact.enabled` and `account_message.enabled` are enabled.

Example:

```hcl
account_message = {
  enabled = true
  messages = [
    {
      msg_type = "..."
      channel  = "..."
      names    = ["..."]
    }
  ]
}
```

#### Shared image baseline

- Added support for the `TCC-AF_SHARE_IMAGE` account baseline.
- Added the optional `share_image` input with the following image attributes:
  - `region`
  - `image_id`
  - `image_name`
- Encoded shared image definitions into the baseline `configuration` payload.

Example:

```hcl
share_image = {
  enabled = true
  images = [
    {
      region     = "ap-singapore"
      image_id   = "img-xxxxxxxx"
      image_name = "shared-base-image"
    }
  ]
}
```

### Changed

#### Organization AssumeRole identity assignments

- Removed the hard-coded administrator identity ID (`1`) from member identity attachments.
- Member attachments now contain only the identity created for the corresponding AssumeRole policy.
- Changed the `for_each` key from `member_uin` to a composite key containing the AssumeRole name and member UIN:

  ```text
  <assume_role_name>-<member_uin>
  ```

- Allows the same organization member to receive identities from multiple AssumeRole policies without duplicate map key collisions.
- Separates identity assignments by policy instead of implicitly including the administrator identity in every attachment.

#### CCN attachment

- Reordered `ccn_uin` alongside `ccn_id` in the CCN attachment resource definition for consistency.
- No functional or interface change is expected from this formatting adjustment.

#### CCN instance

- Renamed CCN input variables for clearer module-level namespacing:

  | Previous variable | New variable |
  |---|---|
  | `bandwidth_limit_type` | `ccn_bandwidth_limit_type` |
  | `charge_type` | `ccn_charge_type` |

- Added `null` as the default value for `src_region`, making the source region optional when a bandwidth limit is not configured.

#### VPC subnet

- Reordered the subnet resource arguments for consistency.
- No functional or interface change is expected.

#### VPN Gateway

- Adjusted resource formatting for readability.
- No functional or interface change is expected.

### Refactored

#### VPC module scope reduction

The VPC module has been simplified to manage only:

- One Tencent Cloud VPC
- Zero or more subnets within the newly created VPC

The module now always creates `tencentcloud_vpc.vpc` and directly associates its subnets with that VPC.

Additional behavior changes include:

- Removed conditional VPC creation.
- Removed support for deploying subnets into an existing VPC.
- Removed automatic availability zone discovery.
- Subnet `availability_zone` values must now be explicitly supplied.
- Removed custom and default route table selection logic.
- Removed route table association from subnet resources.
- Simplified `vpc_id` output to reference the directly managed VPC resource.

### Removed

#### VPC module resources and capabilities

The following capabilities have been removed from `modules/vpc`:

- Existing VPC lookup and reuse
- Conditional VPC creation
- Availability zone discovery
- Custom route table creation
- Route table entry creation
- VPN Gateway creation
- Network ACL creation and subnet attachment
- NAT Gateway and EIP creation
- VPC attachment to CCN

These capabilities should be managed through dedicated Terraform modules.

#### VPC module inputs

Removed inputs include, but are not limited to:

- `vpc_region`
- `create_vpc`
- `vpc_id`
- `default_subnet_name`
- `availability_zones`
- Route table and route entry inputs
- VPN Gateway inputs
- Network ACL inputs
- NAT Gateway and EIP inputs
- CCN attachment inputs

#### VPC module outputs

Removed outputs include:

- `route_table_id`
- `route_entry_id`
- `availability_zones`
- `tags`
- `vpn_gateway_id`
- `vpn_gateway_public_ip_address`
- `network_acl_id`
- `nat_gateway_id`
- `nat_public_ips`

The remaining outputs are:

- `vpc_id`
- `subnet_ids`

### Breaking Changes

#### VPC module

> The VPC module refactoring is a major interface and behavior change.

- The module can no longer manage or reuse an existing VPC through `vpc_id`.
- `create_vpc = false` is no longer supported.
- Removed resources must be migrated to dedicated modules before upgrading.
- Consumers referencing removed outputs will fail during Terraform validation.
- Each subnet must explicitly define `availability_zone`; automatic zone selection has been removed.
- Existing Terraform state addresses may no longer match the refactored resource addresses.
- Removing the old resources without migrating state or configuration may cause Terraform to propose resource destruction.

#### CCN instance module

Consumers must rename the following arguments:

```hcl
bandwidth_limit_type = "OUTER_REGION_LIMIT"
charge_type          = "POSTPAID"
```

to:

```hcl
ccn_bandwidth_limit_type = "OUTER_REGION_LIMIT"
ccn_charge_type          = "POSTPAID"
```

#### AssumeRole identity attachments

Removing the hard-coded administrator identity may update existing organization member identity attachments. Review the Terraform plan to confirm that required administrative access is not unintentionally removed.

### Migration Notes

1. Update all CCN module calls to use `ccn_bandwidth_limit_type` and `ccn_charge_type`.
2. Identify every removed `modules/vpc` input and output used by calling configurations.
3. Move route tables, routes, VPN Gateways, network ACLs, NAT Gateways, EIPs, and CCN attachments to dedicated modules.
4. If an existing VPC must be reused, use dedicated subnet and network component modules instead of the refactored VPC module.
5. Add an explicit `availability_zone` to every item in `subnet_cidrs`.
6. Update references to removed VPC outputs with outputs from the corresponding dedicated modules.
7. Use Terraform `moved` blocks, `terraform state mv`, or resource imports where resources are transferred to dedicated modules.
8. Review AssumeRole attachment changes and explicitly manage any administrator identity that is still required.
9. Enable and configure the new account notification and shared image baselines only where required.
10. Run `terraform validate` and carefully review `terraform plan` before applying the upgrade.

### Validation Checklist

- [ ] Account notification payloads contain valid message types, channels, and recipient names
- [ ] Account notification behavior with the `account_contact.enabled` dependency is confirmed
- [ ] Shared image IDs exist in the specified regions and can be shared with target accounts
- [ ] The same organization member can be assigned to multiple AssumeRole policies
- [ ] Required administrator identities remain attached after the AssumeRole change
- [ ] All CCN instance calls use the renamed input variables
- [ ] Every subnet specifies an explicit availability zone
- [ ] Removed VPC capabilities are managed by dedicated modules
- [ ] No calling configuration references removed VPC inputs or outputs
- [ ] Terraform state has been migrated before removing legacy VPC-managed resources
- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes
- [ ] `terraform plan` contains no unintended resource destruction or replacement

### Suggested Release Title

```text
feat(account-factory)!: add new baselines and simplify network modules
```

### Suggested Commit Message

```text
feat(account-factory)!: add notification and shared image baselines

- add account notification and shared image baseline configurations
- support multiple AssumeRole policies for the same organization member
- remove implicit administrator identity attachments
- namespace CCN instance input variables
- simplify the VPC module to manage only VPCs and subnets
- remove route, VPN, ACL, NAT, and CCN attachment management from the VPC module

BREAKING CHANGE: the VPC module no longer supports existing VPCs or auxiliary
network resources, and CCN input variables have been renamed.
```


## August 18, 2026

### Summary

Fixed account baseline batch application to preserve and pass each baseline item's configuration to the Tencent Cloud provider resource.

### Fixed

#### Account baseline configuration

- Updated the `baseline_config_items` dynamic block in `components/account-factory/baseline/account-baselines/main.tf`.
- Included both `identifier` and `configuration` when constructing the collection used by `for_each`.
- Ensured `baseline_config_items.value.configuration` is available when rendering each baseline configuration item.
- Prevented baseline configuration values from being dropped before they are passed to `tencentcloud_batch_apply_account_baselines`.

### Before

```hcl
for_each = [
  for item in local.baseline_items : {
    identifier = item.identifier
  }
]
```

### After

```hcl
for_each = [
  for item in local.baseline_items : {
    identifier    = item.identifier
    configuration = item.configuration
  }
]
```

### Impact

This fix allows account baselines that require configuration data to be applied correctly. No input variable or module interface changes are introduced.

### Validation Checklist

- [ ] `terraform fmt -check` passes
- [ ] `terraform validate` passes
- [ ] Every baseline item contains the expected `identifier` and `configuration`
- [ ] `terraform plan` includes the intended baseline configuration values
- [ ] Batch baseline application completes without a missing `configuration` attribute error
- [ ] Existing baseline assignments without custom configuration remain unaffected

### Suggested Release Title

```text
fix(account-baselines): preserve baseline item configuration
```

### Suggested Commit Message

```text
fix(account-baselines): pass baseline item configuration

- include configuration in the baseline_config_items iteration value
- preserve configuration when applying account baselines in batch
- prevent missing configuration attribute errors
```


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
