## August 28, 2026

## Summary

This release refactors Control Center service-linked role handling for account baselines and improves CLS index-rule configuration for CloudAudit and Config components. CLS rule sections are now optional, dynamic indexing is supported, and validation prevents unsupported duplicate rule blocks.

> [!WARNING]
> In the supplied diff, `modules/controlcenter-account-baseline-config/main.tf` removes the declaration of `tencentcloud_cam_service_linked_role.cc_role` but retains it in `depends_on`. Confirm that the resource was moved to another `.tf` file in the module. Otherwise, `terraform validate` will fail with an undeclared-resource error.

## Added

### Account baseline CAM strategy control

Added the following variable to both the Account Baselines component and the Control Center account baseline module:

```hcl
variable "create_cam_strategy" {
  type        = bool
  default     = false
  description = "Specify whether to create CAM role and relative TKE essential policy. Set to false if you've enable by using TencentCloud Console."
}
```

This input is intended to control whether the required CAM role or strategy is created automatically instead of assuming that the component always owns the service-linked role.

### CLS dynamic indexing

Added `dynamic_index` support to the CloudAudit CLS index-rule schema:

```hcl
dynamic_index = optional(list(object({
  status = bool
})), [])
```

This allows callers to configure the CLS automatic key-value indexing switch.

### CLS rule validation

Added validation to the CloudAudit and Config components to enforce Tencent Cloud CLS rule cardinality constraints:

- A maximum of one top-level `cls_rules` entry.
- A maximum of one `full_text` block per rule.
- A maximum of one `key_value` block per rule.
- A maximum of one `tag` block per rule.
- A maximum of one `dynamic_index` block per rule.

Invalid configurations now fail during Terraform input validation instead of failing later during provider execution.

## Changed

### Account Baselines component

- Removed the inline lookup of `ControlCenter_QCSLinkedRoleInAccountsEntMng` from `components/account-factory/baseline/account-baselines/main.tf`.
- Removed inline creation of the Control Center service-linked role from the component's main resource file.
- Added `create_cam_strategy` with a default value of `false`.
- Prepared CAM role ownership to be controlled explicitly or implemented separately from the baseline resource logic.

### Control Center account baseline module

- Removed the CAM role lookup and service-linked role declaration from `modules/controlcenter-account-baseline-config/main.tf`.
- Removed the local `role_list` used to conditionally create the role.
- Added the `create_cam_strategy` input with a default value of `false`.
- Simplified the baseline resource dependency formatting.

### CloudAudit CLS index rules

Refactored `cls_rules` so that each index section is optional and defaults to an empty list:

- `full_text`
- `key_value`
- `tag`
- Nested `key_values`
- Nested field `value` definitions

The following nested field attributes are now optional:

- `tokenizer`
- `sql_flag`
- `contain_z_h`

Descriptions and inline comments were expanded to document supported field types, delimiters, SQL analysis, Chinese character handling, and CLS metadata behavior.

### Config CLS index rules

Added the same top-level and nested rule-count validation used by the CloudAudit component, keeping CLS index behavior consistent across both audit components.

## Compatibility

### CLS configuration

The CLS schema change is backward compatible for valid existing configurations because previously required blocks remain accepted. Callers can now omit unused index sections and optional nested properties.

Configurations containing multiple top-level rules or repeated index sections will now fail variable validation. These configurations should be consolidated into one supported CLS rule definition.

### CAM role behavior

The new `create_cam_strategy` variable defaults to `false`, which may change deployment behavior if service-linked role creation is moved behind this flag. Deployments that rely on Terraform to create the Control Center role should explicitly enable the option after confirming its implementation.

## Potential Release Blockers

### Remaining undeclared CAM role dependency

The supplied module diff retains:

```hcl
depends_on = [tencentcloud_cam_service_linked_role.cc_role]
```

while removing that resource from `main.tf`. Before release, confirm that `cc_role` exists in another Terraform file. If it does not, either restore/create the resource or remove the stale dependency.

### Unused `create_cam_strategy` input

The supplied diff adds `create_cam_strategy`, but no usage of the variable is visible. Confirm that another file uses it to conditionally create the required CAM resource. Otherwise, the input has no effect and should not be advertised as functional.

### Variable description mismatch

The `create_cam_strategy` description refers to a “TKE essential policy,” while the affected resources relate to the Control Center account baseline service-linked role. Update the description if this wording was copied from a TKE module.

## Migration Notes

1. Determine whether the Control Center service-linked role is managed by Terraform or enabled through the Tencent Cloud Console.
2. If Terraform should manage it, set `create_cam_strategy = true` after confirming that the variable controls an actual CAM resource.
3. If the role is externally managed, leave `create_cam_strategy = false` and verify that `ControlCenter_QCSLinkedRoleInAccountsEntMng` already exists.
4. Consolidate CLS configurations so `cls_rules` contains no more than one rule object.
5. Ensure each rule contains no more than one `full_text`, `key_value`, `tag`, and `dynamic_index` block.
6. Remove empty CLS sections where appropriate; they can now be omitted.
7. Review `terraform plan` for unexpected CAM role deletion or baseline dependency changes.

## Validation Checklist

- [ ] Run `terraform fmt -recursive`.
- [ ] Run `terraform validate` for both account baseline layers.
- [ ] Confirm `tencentcloud_cam_service_linked_role.cc_role` is declared in the module.
- [ ] Confirm `create_cam_strategy` is used by a resource or module call.
- [ ] Correct the TKE-specific wording in the CAM strategy variable description.
- [ ] Verify baseline creation when the Control Center service-linked role already exists.
- [ ] Verify baseline creation when Terraform must create the required role.
- [ ] Validate CloudAudit with only a full-text index.
- [ ] Validate CloudAudit with key-value and tag indexes.
- [ ] Validate CloudAudit dynamic indexing.
- [ ] Confirm multiple rule blocks are rejected with clear validation errors.
- [ ] Validate the Config component with the updated CLS constraints.
- [ ] Review the final plan for unintended role or baseline replacement.


## August 26, 2026

## Summary

This change refactors the CloudAudit component storage configuration, renames the audit account input to use Tencent Cloud UIN terminology, and updates CLS topic references for count-based resource addressing. It also removes the inline COS and CLS storage resource definitions from `main.tf`.

> [!WARNING]
> The supplied diff removes the COS bucket, COS bucket policy, CLS logset, CLS topic, and CLS index resources, but the CloudAudit track and outputs still reference several of those resources. Unless the resources were moved to other Terraform files that are not included in this diff, the component will fail validation with undeclared-resource errors.

## Changed

### CloudAudit account identifier

- Renamed the component input variable:

  ```text
  account_id -> account_uin
  ```

- Updated `tencentcloud_audit_track.track.storage.storage_account_id` to use `var.account_uin` directly.
- Removed the automatic fallback that previously resolved the current account UIN through `data.tencentcloud_user_info.info.uin`.
- Retained automatic App ID resolution through `data.tencentcloud_user_info.info.app_id` when `app_id` is not provided.

### CLS topic references

- Updated the CloudAudit track storage reference from:

  ```hcl
  tencentcloud_cls_topic.topic.id
  ```

  to:

  ```hcl
  tencentcloud_cls_topic.topic[0].id
  ```

- Updated the `topic_id` output to use the same count-indexed CLS topic reference.

### Resource dependencies

- Removed `tencentcloud_cam_role_policy_attachment.role_policies` from the explicit CloudAudit track dependency list.
- Retained dependencies on the CAM role and storage resources.

### CAM role formatting

- Reformatted the conditional CAM role `count` declaration without changing its behavior.

## Removed

The following inline storage resources were removed from `components/audit-log/cloud-audit/main.tf`:

- `tencentcloud_cos_bucket.bucket`
- `tencentcloud_cos_bucket_policy.cos_bucket_policy`
- `tencentcloud_cls_logset.logset`
- `tencentcloud_cls_topic.topic`
- `tencentcloud_cls_index.index`

The removed implementation previously managed:

- COS bucket creation and lifecycle rules
- CloudAudit COS bucket access policy
- CLS logset and topic provisioning
- CLS topic retention, partitioning, encryption, and tagging
- CLS index rules for full-text, key-value, and tag fields

## Breaking Changes

### Input variable rename

All callers must replace `account_id` with `account_uin`.

Before:

```hcl
module "cloud_audit" {
  source = "..."

  account_id = "100000000001"
}
```

After:

```hcl
module "cloud_audit" {
  source = "..."

  account_uin = "100000000001"
}
```

### Account UIN is no longer resolved automatically

The previous implementation used the current Tencent Cloud account UIN when `account_id` was not provided. The updated implementation passes `var.account_uin` directly to `storage_account_id`.

Callers must now explicitly provide a valid account UIN unless the provider resource accepts a null value for the selected storage configuration.

### Storage resource ownership

The component no longer defines its COS and CLS storage resources in `main.tf`. If this removal is intentional, storage resources must be provisioned elsewhere and the component interface must accept their identifiers instead of referencing local resources.

Existing Terraform state for removed resources may otherwise be planned for destruction. Review the plan before applying and migrate state if resource ownership is moving to dedicated modules.

## Release Blocker

Based only on the supplied diff, the following references remain after their resource declarations were removed:

```hcl
tencentcloud_cos_bucket.bucket
tencentcloud_cls_logset.logset
tencentcloud_cls_topic.topic
tencentcloud_cls_index.index
```

Affected locations include:

- CloudAudit track `storage_name`
- CloudAudit track `depends_on`
- `topic_id` output
- Potentially the existing `bucket_id`, `logset_id`, and `index_id` outputs

Before merging, confirm one of the following:

1. These resources were moved to other `.tf` files in the same component; or
2. The remaining references and outputs will be replaced with module inputs or dedicated storage module outputs.

## Migration Notes

1. Rename `account_id` to `account_uin` in all Terraform and Terragrunt callers.
2. Explicitly provide the Tencent Cloud account UIN used by CloudAudit storage.
3. Confirm whether COS and CLS resources were moved to separate files or dedicated modules.
4. If storage ownership is moving, add the required bucket, logset, topic, and index IDs as component inputs.
5. Use `terraform state mv` to transfer existing resources to their new module addresses when applicable.
6. Run `terraform plan` and verify that no COS bucket, bucket policy, CLS logset, topic, or index is unintentionally destroyed.
7. Confirm that count-indexed references such as `topic[0].id` match the final CLS resource declaration.

## Validation Checklist

- [ ] Run `terraform fmt -recursive`.
- [ ] Run `terraform validate` for the CloudAudit component.
- [ ] Confirm no undeclared resource references remain.
- [ ] Confirm all callers use `account_uin` instead of `account_id`.
- [ ] Verify that `account_uin` is supplied for COS and CLS storage scenarios.
- [ ] Verify CLS topic count/index behavior.
- [ ] Verify CloudAudit delivery to COS.
- [ ] Verify CloudAudit delivery to CLS.
- [ ] Review output expressions for bucket, logset, topic, and index IDs.
- [ ] Review the Terraform plan for unintended storage resource destruction.
- [ ] Migrate Terraform state before applying if storage resources were moved.


## August 25, 2026

## Summary

This release updates the CCN VPN, CIC Role, PostgreSQL, CLB, CVM, security, and authorization modules, refreshes Terraform/provider compatibility metadata across multiple modules, and introduces a standalone TDMQ Pulsar module.

> [!NOTE]
> This changelog is based on the supplied Git working-tree file list. Except for the previously reviewed CIC Role changes, exact input, output, resource behavior, and version constraint changes should be verified against the complete `git diff` before release.

## Added

### TDMQ Pulsar

- Added a standalone `modules/tdmq-pulsar` module.
- Introduced a dedicated module boundary for provisioning and managing Tencent Distributed Message Queue for Pulsar resources.
- Enabled TDMQ Pulsar to be composed independently in Landing Zone and application infrastructure deployments.

## Changed

### CCN VPN Component

- Updated the `components/network/ccn-vpn` resource implementation.
- Revised the component input variables and exported outputs.
- Aligned the CCN VPN component interface with the current modular network architecture.

### CIC Role Component

- Changed preset policy attachment instance keys from policy IDs to policy names:

  ```text
  <role_name>-<policy_id>
  ```

  becomes:

  ```text
  <role_name>-<policy_name>
  ```

- Renamed the role-assignment input field:

  ```text
  target_account_name -> target_name
  ```

- Updated organization member lookup and role assignment logic to use `target_name`.
- Added the `cic_roles` output, exposing a map of CIC role configuration names to role configuration IDs.
- Reformatted preset and custom policy attachment outputs for readability.

### PostgreSQL Module

- Updated the `modules/cdb-postgres` resource implementation and input interface.
- Refreshed module version and provider compatibility metadata.
- Prepared the module for updated PostgreSQL provisioning requirements.

### CLB Modules

- Updated CLB instance resource configuration and variables.
- Updated CLB listener resource configuration and variables.
- Updated CLB redirection behavior.
- Aligned the CLB module interfaces with the current load-balancing resource model.

### CVM Module

- Updated the `modules/cvm-instance` input variable definitions.

### Module Compatibility Metadata

Updated Terraform/provider version constraints or compatibility metadata for:

- CAM Role
- TCR
- TKE Authorization
- Cloud Firewall address templates
- Cloud Firewall edge firewall switches and policies
- Cloud Firewall NAT instances, switches, and policies
- Cloud Firewall VPC instances, switches, and policies
- Cloud Firewall asset and route synchronization
- WAF attack allowlist rules
- WAF CC protection
- WAF CLB domains and instances
- WAF custom rules
- WAF attack-log delivery configuration
- WAF CKafka and CLS log-delivery flows
- WAF SaaS domains, instances, and IP access control

## Breaking Changes

### CIC Role Assignment Input Rename

The `role_assignments` object no longer uses `target_account_name`. Callers must rename it to `target_name`.

Before:

```hcl
role_assignments = [
  {
    role_name           = "Administrator"
    principal_id        = "u-example"
    principal_type      = "User"
    target_account_name = "production"
    target_type         = "MemberUin"
  }
]
```

After:

```hcl
role_assignments = [
  {
    role_name      = "Administrator"
    principal_id   = "u-example"
    principal_type = "User"
    target_name    = "production"
    target_type    = "MemberUin"
  }
]
```

### CIC Preset Policy Attachment Keys

Changing the Terraform `for_each` key from the preset policy ID to the policy name changes affected resource addresses. Without state migration, Terraform may plan to destroy and recreate existing policy attachment resources.

Review the plan and migrate state where required:

```bash
terraform state mv \
  'tencentcloud_identity_center_role_configuration_permission_policy_attachment.attachment["<role-name>-<policy-id>"]' \
  'tencentcloud_identity_center_role_configuration_permission_policy_attachment.attachment["<role-name>-<policy-name>"]'
```

### Other Module Interfaces

The CCN VPN, PostgreSQL, CLB, and CVM variable files have changed. Confirm whether any inputs were added, removed, renamed, or had their types/defaults changed before upgrading consumers.

## Migration Notes

1. Replace every CIC Role assignment field named `target_account_name` with `target_name`.
2. Run `terraform plan` for CIC Role deployments and identify preset policy attachments whose resource addresses changed.
3. Use `terraform state mv` for existing CIC policy attachments when the underlying attachment must be preserved.
4. Review CCN VPN input/output references in all component callers.
5. Review PostgreSQL, CLB, and CVM module calls against their updated variable definitions.
6. Run `terraform init -upgrade` where module version constraints or provider requirements changed.
7. Validate the new TDMQ Pulsar module in a non-production environment before adoption.

## Validation Checklist

- [ ] Run `terraform fmt -recursive`.
- [ ] Run `terraform init -upgrade` for affected stacks.
- [ ] Run `terraform validate` for every changed module and component.
- [ ] Confirm CIC Role callers use `target_name`.
- [ ] Review CIC preset policy attachment state addresses.
- [ ] Confirm the new `cic_roles` output is consumed correctly.
- [ ] Verify CCN VPN inputs and outputs against existing Terragrunt dependencies.
- [ ] Verify PostgreSQL provisioning and upgrade plans.
- [ ] Verify CLB instance, listener, and redirection plans.
- [ ] Verify provider version compatibility across CAM, CFW, TCR, TKE, and WAF modules.
- [ ] Validate TDMQ Pulsar creation, outputs, and lifecycle behavior.
- [ ] Review the final plan for unexpected replacement or deletion operations.


## August 20, 2026

### Summary

This release enhances CloudAudit components with dedicated CAM permission configuration, updates container and TKE-related access policies, and adds standalone MongoDB and Redis Terraform modules.

- Added 5 new files or module directories
- Updated 9 existing Terraform files
- Affected CloudAudit, CAM, TCR, TKE, MongoDB, and Redis capabilities

### Added

#### CloudAudit CAM configuration

- Added `components/audit-log/cloud-audit/cam.tf` for component-level CloudAudit permission management.
- Added `modules/cloudaudit-events-track/cam.tf` for CAM permissions required by CloudAudit event tracking.
- Added `modules/cloudaudit-track/cam.tf` for CAM permissions required by CloudAudit tracking and log delivery.
- Separates IAM authorization from the core CloudAudit resource definitions.

#### MongoDB module

- Added `modules/mongodb/` for standalone TencentDB for MongoDB provisioning and management.
- Provides a reusable database module for application and Landing Zone deployments.

#### Redis module

- Added `modules/redis/` for standalone TencentDB for Redis provisioning and management.
- Provides a reusable cache module for application and Landing Zone deployments.

### Changed

#### CloudAudit component

Updated the CloudAudit component implementation and input interface:

- `components/audit-log/cloud-audit/main.tf`
- `components/audit-log/cloud-audit/variables.tf`

The component is now aligned with the dedicated CAM configuration introduced in `cam.tf`.

#### CloudAudit event tracking module

Updated CloudAudit event tracking resources and variables:

- `modules/cloudaudit-events-track/main.tf`
- `modules/cloudaudit-events-track/variables.tf`

The module now includes standalone CAM permission configuration.

#### CloudAudit tracking module

Updated CloudAudit tracking resources and variables:

- `modules/cloudaudit-track/main.tf`
- `modules/cloudaudit-track/variables.tf`

The module now includes standalone CAM permission configuration for audit tracking and delivery workflows.

#### TCR module

- Updated `modules/tcr/cam.tf`.
- Refined CAM policies or role assignments used by Tencent Container Registry resources.

#### TKE instance module

- Updated `modules/tke-instance/cam.tf`.
- Refined CAM permissions used during TKE worker node provisioning and operation.

#### TKE native node pool module

- Updated `modules/tke-native-node-pool/main.tf`.
- Aligned native node pool provisioning with the updated TKE and CAM module structure.

### Compatibility Notes

- CloudAudit consumers should review newly introduced CAM resources and permissions before applying the changes.
- Existing manually managed CloudAudit roles or policies may overlap with the new Terraform-managed CAM resources.
- TCR and TKE permission changes may update existing policies or attachments.
- New MongoDB and Redis modules are additive and do not affect existing deployments unless explicitly referenced.

### Migration Notes

1. Review the new CloudAudit CAM resources and identify any equivalent permissions currently managed outside Terraform.
2. Import existing CAM roles, policies, or attachments when necessary to avoid duplicate resources.
3. Compare updated CloudAudit variables with existing component and module calls.
4. Review TCR and TKE CAM policy changes for least-privilege compliance.
5. Verify that TKE native node pool identities retain all permissions required for provisioning and operation.
6. Adopt `modules/mongodb` and `modules/redis` only where the corresponding managed database services are required.
7. Run `terraform init -upgrade`, `terraform validate`, and `terraform plan` before applying the changes.

### Validation Checklist

- [ ] CloudAudit tracking resources can assume or use the required CAM identities
- [ ] CloudAudit logs and events are delivered to the intended destinations
- [ ] No duplicate CAM roles, policies, or attachments are proposed
- [ ] TCR operations retain the required permissions
- [ ] TKE worker nodes retain the required CAM permissions
- [ ] TKE native node pool changes do not trigger unintended replacement
- [ ] MongoDB module inputs, outputs, encryption, networking, and access controls are validated
- [ ] Redis module inputs, outputs, encryption, networking, and access controls are validated
- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes
- [ ] `terraform plan` contains no unintended resource destruction or privilege expansion



## August 20, 2026

### Summary

This release reorganizes security group and PostgreSQL modules, adds standalone SSH key and TCR modules, and expands the modular TKE stack with authorization and log configuration capabilities.

- Added 8 new component, example, or module directories
- Updated 13 existing Terraform files
- Removed 10 legacy component, example, and module files
- Affected CAM, networking, PostgreSQL, SSH key, TCR, and TKE capabilities

### Added

#### Security group component

- Added `components/network/security-group/` as the dedicated security group component.
- Added the corresponding example under `examples/components/network/security-group/`.
- Replaces the abbreviated legacy `components/network/sg/` component path.

#### PostgreSQL modules

- Added `modules/cdb-postgres/` for primary TencentDB for PostgreSQL instance management.
- Added `modules/cdb-postgres-readonly/` for PostgreSQL read-only instance management.
- Separates primary and read-only database responsibilities into dedicated modules.

#### SSH key module

- Added `modules/ssh-key/` for standalone SSH key management.
- Enables compute and TKE modules to consume SSH keys through a reusable module interface.

#### TCR module

- Added `modules/tcr/` for Tencent Container Registry resource management.
- Provides a reusable module for container registry capabilities used by TKE workloads.

#### TKE authorization module

- Added `modules/tke-authz/` for standalone TKE authorization configuration.
- Separates cluster authorization responsibilities from node instance management.

#### TKE log configuration module

- Added `modules/tke-log-config/` for standalone TKE log collection and delivery configuration.
- Separates logging configuration from the core TKE cluster and node modules.

### Changed

#### CAM role module

Updated the CAM role module implementation and interface:

- `modules/cam-role/main.tf`
- `modules/cam-role/variables.tf`
- `modules/cam-role/outputs.tf`
- `modules/cam-role/versions.tf`

Consumers should review input variables, outputs, and provider constraints before upgrading.

#### TKE cluster endpoint module

Updated TKE cluster endpoint resource definitions and input variables:

- `modules/tke-cluster-endpoint/main.tf`
- `modules/tke-cluster-endpoint/variables.tf`

Consumers should review endpoint access, network, and security-related arguments for compatibility.

#### TKE instance module

Updated TKE node instance and CAM integration:

- `modules/tke-instance/cam.tf`
- `modules/tke-instance/main.tf`
- `modules/tke-instance/variables.tf`
- `modules/tke-instance/outputs.tf`

The changes align instance provisioning with the expanded TKE module structure, including standalone authorization and SSH key capabilities.

#### TKE native node pool module

Updated native node pool resource definitions, variables, and outputs:

- `modules/tke-native-node-pool/main.tf`
- `modules/tke-native-node-pool/variables.tf`
- `modules/tke-native-node-pool/outputs.tf`

Consumers should review node pool arguments and downstream output references before upgrading.

### Removed

#### Legacy security group component

Removed `components/network/sg/`, including:

- `README.md`
- `main.tf`
- `outputs.tf`
- `variables.tf`
- `versions.tf`

Also removed the legacy example:

- `examples/components/network/sg/main.tf`

Use the new `components/network/security-group/` path and example instead.

#### Legacy PostgreSQL instance module

Removed `modules/cdb-postgres-instance/`, including:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `version.tf`

Use the following modules instead:

- `modules/cdb-postgres/` for primary PostgreSQL instances
- `modules/cdb-postgres-readonly/` for read-only PostgreSQL instances

### Breaking Changes

> This refactoring changes component and module source paths and may also change variables, outputs, provider constraints, and Terraform resource addresses.

- `components/network/sg` has been removed and replaced by `components/network/security-group`.
- `modules/cdb-postgres-instance` has been removed and replaced by separate primary and read-only PostgreSQL modules.
- Existing references to removed module outputs will fail until updated.
- CAM role and TKE module interfaces may have changed.
- TKE authorization and logging responsibilities may now require explicit standalone module declarations.
- Moving existing resources to new module paths without Terraform state migration may cause unexpected resource destruction or recreation.

### Migration Notes

1. Replace references to `components/network/sg` with `components/network/security-group`.
2. Update security group examples and documentation to use the new component path.
3. Replace `modules/cdb-postgres-instance` with `modules/cdb-postgres` for primary instances.
4. Use `modules/cdb-postgres-readonly` for read-only database instances.
5. Compare old and new PostgreSQL variables and outputs before changing module sources.
6. Review changes to `modules/cam-role`, including provider constraints and output names.
7. Review TKE cluster endpoint, instance, and native node pool input and output changes.
8. Add `modules/tke-authz` and `modules/tke-log-config` explicitly where authorization and logging are required.
9. Adopt `modules/ssh-key` and `modules/tcr` where shared SSH key or container registry resources should be managed independently.
10. Use Terraform `moved` blocks, `terraform state mv`, or resource imports when transferring existing resources to new module addresses.
11. Run `terraform init -upgrade`, `terraform validate`, and `terraform plan` before applying the upgrade.

### Validation Checklist

- [ ] All security group component references use `components/network/security-group`
- [ ] Security group examples use the new component path
- [ ] PostgreSQL callers use the appropriate primary or read-only module
- [ ] Existing PostgreSQL resources have been mapped to their new Terraform state addresses
- [ ] CAM role consumers match the updated variables and outputs
- [ ] TKE endpoint access settings remain correct
- [ ] TKE instance and native node pool plans contain no unintended replacement
- [ ] TKE authorization is configured through the intended module
- [ ] TKE log collection and delivery are configured through the intended module
- [ ] SSH keys and TCR resources are created only where required
- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes
- [ ] `terraform plan` contains no unintended resource destruction or recreation


## August 19, 2026

### Summary

Added a new Terraform component for managing CIC roles within the Tencent Cloud organization structure.

### Added

#### CIC role component

- Added the new `components/organization/cic-role/` component.
- Provides a dedicated organization-level component for CIC role configuration and lifecycle management.
- Separates CIC role management from other organization and identity components.

### Validation Checklist

- [ ] The component includes the required Terraform resource definitions
- [ ] Input variables are documented and use appropriate types and defaults
- [ ] Required outputs are exposed for downstream components
- [ ] Tencent Cloud provider version constraints are defined
- [ ] Example usage or README documentation is included
- [ ] `terraform fmt -check` passes
- [ ] `terraform init -backend=false` succeeds
- [ ] `terraform validate` passes
- [ ] `terraform plan` contains only the intended CIC role resources



## August 19, 2026

### Summary

This release restructures the Terraform networking stack by replacing legacy CCN components with a consolidated CCN component, extracting NAT Gateway and EIP management into dedicated modules, and introducing a standalone CCN route-switch module.

- Added 4 new component or module directories
- Updated 12 existing Terraform files
- Removed 9 files from legacy CCN implementations
- Refactored CCN, VPC, NAT Gateway, EIP, and CLS-related module interfaces

### Added

#### Consolidated CCN component

- Added `components/network/ccn/` as the consolidated component for CCN provisioning and orchestration.
- Replaces the legacy `components/network/ccn-instance/` component.

#### NAT Gateway component

- Added `components/network/nat-gateway/` to provide component-level orchestration for NAT Gateway resources.
- Separates NAT Gateway deployment from the core VPC module.

#### CCN route-switch module

- Added `modules/ccn-route-switch/` for independently managing CCN route switching behavior.
- Replaces the legacy `modules/ccn-routes/` implementation.

#### EIP module

- Added `modules/eip/` for standalone Elastic IP provisioning and management.
- Enables EIP resources to be managed independently from NAT Gateway and VPC resources.

### Changed

#### CCN-VPC component

Updated the CCN-VPC component resource definitions, variables, and outputs:

- `components/network/ccn-vpc/main.tf`
- `components/network/ccn-vpc/variables.tf`
- `components/network/ccn-vpc/outputs.tf`

The component has been aligned with the refactored CCN module structure and standalone network modules.

#### CCN instance module

Updated the CCN instance module resource definitions and input interface:

- `modules/ccn-instance/main.tf`
- `modules/ccn-instance/variables.tf`

Consumers should review module arguments for compatibility with the consolidated CCN component.

#### NAT Gateway module

Updated the NAT Gateway module implementation, variables, and outputs:

- `modules/nat-gateway/main.tf`
- `modules/nat-gateway/variables.tf`
- `modules/nat-gateway/output.tf`

The module is now intended to work with the dedicated NAT Gateway component and standalone EIP module.

#### VPC module

Updated the VPC module implementation, variables, and outputs:

- `modules/vpc/main.tf`
- `modules/vpc/variables.tf`
- `modules/vpc/output.tf`

The VPC module continues to be decoupled from auxiliary network resources, which are now managed through dedicated modules and components.

#### CLS Create module

- Updated `modules/cls-create/variables.tf`.
- Consumers should review the changed variable definitions before upgrading.

### Removed

#### Legacy CCN instance component

Removed `components/network/ccn-instance/`, including:

- `README.md`
- `main.tf`
- `outputs.tf`
- `variables.tf`
- `versions.tf`

Use `components/network/ccn/` instead.

#### Legacy CCN routes module

Removed `modules/ccn-routes/`, including:

- `main.tf`
- `outputs.tf`
- `variables.tf`
- `version.tf`

Use `modules/ccn-route-switch/` for CCN route switching behavior.

### Breaking Changes

> This network module refactoring may require updates to module sources, variables, outputs, and Terraform state addresses.

- `components/network/ccn-instance` has been removed and replaced by `components/network/ccn`.
- `modules/ccn-routes` has been removed and replaced by `modules/ccn-route-switch`.
- Existing references to removed CCN component outputs will fail until updated.
- NAT Gateway and EIP responsibilities are now separated into dedicated modules and components.
- VPC, NAT Gateway, CCN-VPC, CCN instance, and CLS variable or output contracts may have changed.
- Moving existing resources to new module paths without state migration may cause Terraform to propose resource recreation or destruction.

### Migration Notes

1. Replace references to `components/network/ccn-instance` with `components/network/ccn`.
2. Replace references to `modules/ccn-routes` with `modules/ccn-route-switch`.
3. Compare the old and new CCN variables and outputs, then update all consumer references.
4. Move NAT Gateway orchestration to `components/network/nat-gateway` where appropriate.
5. Manage Elastic IP resources through `modules/eip` instead of embedding them in VPC or NAT Gateway configurations.
6. Review changes to `components/network/ccn-vpc` and update dependency outputs.
7. Review the updated `modules/cls-create` variable contract.
8. Use Terraform `moved` blocks, `terraform state mv`, or resource imports to preserve resources transferred to new module addresses.
9. Run `terraform init -upgrade`, `terraform validate`, and `terraform plan` before applying the upgrade.

### Validation Checklist

- [ ] All references to the removed CCN component and route module have been updated
- [ ] CCN-VPC dependencies use the new CCN outputs
- [ ] NAT Gateway and EIP resources are managed by the intended dedicated modules
- [ ] No obsolete VPC, NAT Gateway, or CCN inputs and outputs remain in calling configurations
- [ ] CLS Create consumers match the updated variable definitions
- [ ] Terraform state has been migrated for resources moved to new module paths
- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes
- [ ] `terraform plan` contains no unintended resource destruction or replacement


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
