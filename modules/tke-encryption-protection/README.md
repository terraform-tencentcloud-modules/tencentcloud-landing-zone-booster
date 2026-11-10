# TKE Encryption Protection Module

Enable [Tencent Cloud TKE Kubernetes encryption protection](https://www.tencentcloud.com/document/product/457) (`tencentcloud_kubernetes_encryption_protection`) in a Landing Zone. This turns on KMS-based encryption (secret encryption) for a TKE cluster.

This module follows the "single-config" convention used by `config-deliver` / `config-recorder` / `cls-logset` across `tc-modules`: a single module instance manages **one** cluster's encryption protection via flat, individually-named input variables (no `for_each`).

## Important: per-cluster, ForceNew, destroy disables encryption

- The resource is **keyed by `cluster_id`** — the cloud keeps **one** encryption-protection config per cluster, and the resource id IS the cluster id. Declaring two instances with the same `cluster_id` makes them fight over the same cloud config.
- `cluster_id` and `kms_configuration` are **ForceNew**: changing them triggers resource recreation (disable then re-enable).
- `terraform destroy` **really disables** encryption protection for the cluster (calls `DisableEncryptionProtection`). Make sure you understand the implication before destroying.

## Features

- Enable KMS encryption protection for a single TKE cluster via flat input variables.
- Supports both the cloud-generated default key (TKE-KMS) and a custom KMS key (`kms_key_id` + `kms_region`).

## Usage

```hcl
module "tke_encryption_protection" {
  source = "../../tc-modules/modules/tke-encryption-protection"

  # Use the cloud-generated default TKE-KMS key
  cluster_id = "cls-xxxxxxxx"
}
```

Or with a custom KMS key:

```hcl
module "tke_encryption_protection" {
  source = "../../tc-modules/modules/tke-encryption-protection"

  cluster_id  = "cls-xxxxxxxx"
  kms_key_id  = "e3a1c2b4-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  kms_region  = "ap-guangzhou"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| tencentcloud | >= 1.81.136 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_id` | Cluster ID. Identifies the resource (the resource id IS the cluster id). ForceNew. | `string` | n/a | yes |
| `kms_key_id` | Custom KMS key ID. If not specified, a default key will be generated (TKE-KMS). Optional. | `string` | `null` | no |
| `kms_region` | Region of the KMS key. Used when generating a default key or customizing the key region. Optional. | `string` | `null` | no |

## Outputs

Because the resource is a single config, every output is a scalar value.

| Name | Description |
|------|-------------|
| `id` | Resource id (the cluster id). |
| `cluster_id` | Cluster id. |
| `status` | KMS encryption status. |
| `kms_key_id` | Custom KMS key ID (`null` means the cloud-generated default TKE-KMS key). |
| `kms_region` | Region of the KMS key. |

## Notes / Constraints

- The cloud keeps **one** encryption-protection config per `cluster_id`. Use exactly one instance of this module per cluster.
- `cluster_id` and `kms_configuration` are ForceNew: modifying them recreates the resource (disable then re-enable encryption).
- `terraform destroy` disables encryption protection for the cluster (provider delete calls `DisableEncryptionProtection`). Re-applying after destroy re-enables it with a fresh default key.
- Omit both `kms_key_id` and `kms_region` to let the cloud generate and manage the default TKE-KMS key.
- `kms_configuration` is a Required list (max 1) in the provider; this module always passes exactly one block.

## Authors

`tc-modules` maintainers.
