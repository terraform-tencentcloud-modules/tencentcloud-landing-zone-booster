## March 30, 2026

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
