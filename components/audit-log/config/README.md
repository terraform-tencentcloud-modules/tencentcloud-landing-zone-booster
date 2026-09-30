# Tencent Cloud Config (Delivery) Component

Terraform component under `components/audit-log/config` for creating and managing Tencent Cloud **Config** delivery (resource configuration tracking) in Tencent Cloud. It is part of the `audit-log` building block of the tencentcloud-landing-zone-booster framework.

The component enables Cloud Config and delivers the collected configuration data (configuration changes / resource list) to either a COS bucket or a CLS log topic.

## Overview

This component creates and manages a Tencent Cloud Config delivery, with support for:

- **Config enablement** – enable/disable Cloud Config and its delivery feature via switches.
- **Multiple delivery targets** – deliver configuration data to COS object storage or CLS log service.
- **Fine-grained delivery content** – choose to deliver configuration changes (`1`), resource list (`2`), or all (`3`).
- **Automatic storage provisioning** – automatically create the COS bucket or CLS logset/topic as the delivery target.
- **Automatic policy configuration** – automatically configure the required access policy for the storage resource.
- **Lifecycle management** – configure COS bucket lifecycle rules for long-term storage.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.125 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.125 |

### IAM Permissions

The executing principal needs the following Tencent Cloud permissions:

| Permission | Description |
|------------|-------------|
| `QcloudCamFullAccess` | Full access to CAM management |
| `QcloudConfigFullAccess` | Full access to Cloud Config |
| `QcloudCOSFullAccess` | Full access to COS |
| `QcloudCLSFullAccess` | Full access to CLS |

### Prerequisites

- The current account must have Cloud Config management permissions.
- The storage region must match the Config delivery region.

---

## Inputs

### Common configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_create_cam_strategy"></a> [create\_cam\_strategy](#input\_create\_cam\_strategy) | `bool` | `false` | Whether to create the CAM role and the relative essential policy. Set to `false` if already enabled via the Tencent Cloud Console. |
| <a name="input_region"></a> [region](#input\_region) | `string` | `null` | Log region. |
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | `string` | `null` | Organization App ID. |
| <a name="input_account_uin"></a> [account\_uin](#input\_account\_uin) | `string` | `null` | Organization member name or UIN for audit. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | `null` | Tags applied to resources. |

### Config / delivery configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_config_enabled"></a> [config\_enabled](#input\_config\_enabled) | `bool` | `true` | Cloud Config switch. |
| <a name="input_deliver_enabled"></a> [deliver\_enabled](#input\_deliver\_enabled) | `bool` | `true` | Delivery switch. |
| <a name="input_deliver_name"></a> [deliver\_name](#input\_deliver\_name) | `string` | - (required) | Delivery service name. |
| <a name="input_deliver_content_type"></a> [deliver\_content\_type](#input\_deliver\_content\_type) | `number` | `1` | Delivery content type: `1` (configuration change), `2` (resource list), `3` (all). |
| <a name="input_deliver_target_type"></a> [deliver\_target\_type](#input\_deliver\_target\_type) | `string` | - (required) | Delivery target type: `COS` or `CLS`. |
| <a name="input_deliver_log_prefix"></a> [deliver\_log\_prefix](#input\_deliver\_log\_prefix) | `string` | `"config-log"` | Log prefix for stored delivery content. |

### COS storage configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_cos_bucket"></a> [cos\_bucket](#input\_cos\_bucket) | `string` | `null` | Existing COS bucket name (if not provided, a new bucket is created). |
| <a name="input_cos_bucket_acl"></a> [cos\_bucket\_acl](#input\_cos\_bucket\_acl) | `string` | `"private"` | COS bucket ACL: `private`, `public-read` or `public-read-write`. |
| <a name="input_cos_multi_az"></a> [cos\_multi\_az](#input\_cos\_multi\_az) | `bool` | `false` | Whether to enable multi-AZ. |
| <a name="input_cos_force_clean"></a> [cos\_force\_clean](#input\_cos\_force\_clean) | `bool` | `true` | Whether to force clean. |
| <a name="input_cos_versioning_enable"></a> [cos\_versioning\_enable](#input\_cos\_versioning\_enable) | `bool` | `true` | Whether to enable versioning. |
| <a name="input_cos_lifecycle_rules"></a> [cos\_lifecycle\_rules](#input\_cos\_lifecycle\_rules) | `list(object)` | `[]` | COS lifecycle rules. |
| `↳ id` | `string` | - | Rule ID. |
| `↳ filter_prefix` | `string` | - | Filter prefix. |
| `↳ expiration` | `object` | - | Expiration config (`days` / `date` / `delete_marker`). |
| `↳ transition` | `list(object)` | `[]` | Storage-class transition config (`days` / `date` / `storage_class`). |
| `↳ non_current_expiration` | `object` | - | Non-current version expiration (`non_current_days`). |
| `↳ non_current_transition` | `list(object)` | `[]` | Non-current version transition (`non_current_days` / `storage_class`). |
| `↳ abort_incomplete_multipart_upload` | `object` | - | Abort incomplete multipart upload (`days_after_initiation`). |
| <a name="input_cos_tags"></a> [cos\_tags](#input\_cos\_tags) | `map(string)` | `null` | Tags for the COS bucket. |

### CLS storage configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_cls_logset_name"></a> [cls\_logset\_name](#input\_cls\_logset\_name) | `string` | `null` | CLS logset name. |
| <a name="input_cls_logset_tags"></a> [cls\_logset\_tags](#input\_cls\_logset\_tags) | `map(string)` | `null` | Logset tags. |
| <a name="input_cls_topic_name"></a> [cls\_topic\_name](#input\_cls\_topic\_name) | `string` | `null` | CLS topic name. |
| <a name="input_cls_auto_split"></a> [cls\_auto\_split](#input\_cls\_auto\_split) | `bool` | `true` | Whether to enable automatic split. |
| <a name="input_cls_max_split_partitions"></a> [cls\_max\_split\_partitions](#input\_cls\_max\_split\_partitions) | `number` | `50` | Max partitions to split into when auto-split is enabled. |
| <a name="input_cls_partition_count"></a> [cls\_partition\_count](#input\_cls\_partition\_count) | `number` | `1` | Number of topic partitions (1-10). |
| <a name="input_cls_period"></a> [cls\_period](#input\_cls\_period) | `number` | `30` | Lifecycle in days (1-366). |
| <a name="input_cls_storage_type"></a> [cls\_storage\_type](#input\_cls\_storage\_type) | `string` | `"hot"` | Topic storage class: `hot` (real-time) or `cold` (offline). |
| <a name="input_cls_describes"></a> [cls\_describes](#input\_cls\_describes) | `string` | `null` | Topic description. |
| <a name="input_cls_hot_period"></a> [cls\_hot\_period](#input\_cls\_hot\_period) | `number` | `0` | Log sinking standard-storage days (`0` = disabled). |
| <a name="input_cls_is_web_tracking"></a> [cls\_is\_web\_tracking](#input\_cls\_is\_web\_tracking) | `bool` | `false` | Whether to enable anonymous web tracking. |
| <a name="input_cls_encryption"></a> [cls\_encryption](#input\_cls\_encryption) | `number` | `null` | Encryption: `0`/unset = none, `1` = KMS-CLS key. Cannot be disabled once enabled. |
| <a name="input_cls_topic_tags"></a> [cls\_topic\_tags](#input\_cls\_topic\_tags) | `map(string)` | `null` | Topic tags. |
| <a name="input_cls_create_index"></a> [cls\_create\_index](#input\_cls\_create\_index) | `bool` | `false` | Whether to create the CLS index. |
| <a name="input_cls_index_status"></a> [cls\_index\_status](#input\_cls\_index\_status) | `bool` | `true` | Whether the index takes effect. |
| <a name="input_cls_include_internal_fields"></a> [cls\_include\_internal\_fields](#input\_cls\_include\_internal\_fields) | `bool` | `false` | Full-text index internal field marker. |
| <a name="input_cls_metadata_flag"></a> [cls\_metadata\_flag](#input\_cls\_metadata\_flag) | `number` | `0` | Metadata flag: `0` included, `1` all, `2` excluded. |
| <a name="input_cls_rules"></a> [cls\_rules](#input\_cls\_rules) | `set(object)` | `[]` | Index rules (only 1 rule allowed). |
| `↳ full_text` | `list(object)` | - | Full-text index config. |
| `↳ key_value` | `list(object)` | - | Key-value index config. |
| `↳ tag` | `list(object)` | - | Tag index config. |
| `↳ dynamic_index` | `list(object)` | - | Dynamic index config. |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_id"></a> [config\_id](#output\_config\_id) | The ID of the Cloud Config delivery. |
| <a name="output_cos_bucket"></a> [cos\_bucket](#output\_cos\_bucket) | The COS bucket name (when `deliver_target_type = "COS"`). |
| <a name="output_cos_bucket_url"></a> [cos\_bucket\_url](#output\_cos\_bucket\_url) | The COS bucket URL (when `deliver_target_type = "COS"`). |
| <a name="output_logset_id"></a> [logset\_id](#output\_logset\_id) | The CLS logset ID (when `deliver_target_type = "CLS"`). |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | The CLS topic ID (when `deliver_target_type = "CLS"`). |
| <a name="output_index_id"></a> [index\_id](#output\_index\_id) | The CLS index ID (when `deliver_target_type = "CLS"` and `cls_create_index = true`). |

---

## Configuration Examples

### `terraform.tfvars` example (deliver to COS)

```hcl
# Common
region          = "ap-guangzhou"
deliver_name    = "prod-config-deliver"
deliver_log_prefix = "config-log"

# Delivery config
config_enabled     = true
deliver_enabled    = true
deliver_target_type = "COS"
deliver_content_type = 3  # all

# COS storage configuration
cos_bucket_acl        = "private"
cos_multi_az          = true
cos_force_clean       = true
cos_versioning_enable = true

cos_lifecycle_rules = [
  {
    id            = "auto-archive"
    filter_prefix = ""

    transition = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
      {
        days          = 90
        storage_class = "ARCHIVE"
      }
    ]
  }
]
```

### `terraform.tfvars` example (deliver to CLS)

```hcl
region          = "ap-guangzhou"
deliver_name    = "prod-config-deliver-cls"
deliver_log_prefix = "config-log"

config_enabled     = true
deliver_enabled    = true
deliver_target_type = "CLS"
deliver_content_type = 1  # configuration change only

# CLS configuration
cls_logset_name = "config-logset"
cls_topic_name  = "config-topic"
cls_period      = 180
cls_storage_type = "hot"
cls_create_index = true
```

---

## Usage Examples

### Example 1: Basic COS delivery

```hcl
module "config_cos" {
  source = "./modules/config"

  region          = "ap-guangzhou"
  deliver_name    = "basic-config-deliver"
  deliver_target_type = "COS"
  deliver_content_type = 3

  cos_bucket_acl        = "private"
  cos_versioning_enable = true
}
```

### Example 2: CLS delivery with index

```hcl
module "config_cls" {
  source = "./modules/config"

  region          = "ap-beijing"
  deliver_name    = "detailed-config-deliver"
  deliver_target_type = "CLS"
  deliver_content_type = 1

  cls_logset_name = "config-logset"
  cls_topic_name  = "config-topic"
  cls_period      = 180
  cls_storage_type = "hot"
  cls_create_index = true
}
```

### Example 3: Existing COS bucket

```hcl
module "config_existing_cos" {
  source = "./modules/config"

  region          = "ap-shanghai"
  deliver_name    = "existing-bucket-deliver"
  deliver_target_type = "COS"
  deliver_content_type = 2  # resource list only

  # Use an existing bucket instead of creating a new one
  cos_bucket = "my-existing-config-bucket"
}
```

### Example 4: Disable delivery

```hcl
module "config_disabled" {
  source = "./modules/config"

  region          = "ap-guangzhou"
  deliver_name    = "disabled-deliver"
  deliver_target_type = "COS"

  config_enabled  = true
  deliver_enabled = false  # delivery off
}
```

---

## Configuration Notes

### Delivery target selection

```
Delivery target selection:
┌──────────────────────────────────────────────┐
│  Check deliver_target_type                    │
│         │                                      │
│  "COS"  → create/use a COS bucket              │
│  "CLS"  → create a CLS logset/topic            │
└──────────────────────────────────────────────┘
```

### Resource dependencies

```
tencentcloud_config_deliver_config.this (create delivery)
          │
          ├─ COS storage (when deliver_target_type = "COS")
          │     └─ COS bucket policy (optional)
          │
          └─ CLS storage (when deliver_target_type = "CLS")
                └─ CLS index (optional, cls_create_index = true)
```

### Delivery content type

| Value | Meaning |
|-------|---------|
| `1` | Configuration change |
| `2` | Resource list |
| `3` | All |

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Required variables**
   - `deliver_name` and `deliver_target_type` have no defaults and must be set explicitly.
   - `deliver_target_type` only supports `COS` or `CLS`.

2. **Region consistency**
   - The storage region must match the Config delivery region.

3. **Existing COS bucket**
   - When `cos_bucket` is provided, the module uses the existing bucket instead of creating a new one.

4. **COS access policy**
   - The module automatically configures the required access policy for the COS bucket.
   - Manually modifying the policy may break delivery.

5. **CLS index**
   - With `cls_create_index = true`, the index is created automatically.
   - Configure `cls_rules` carefully per your needs. Only one rule block is allowed.

6. **Cost considerations**
   - COS cost depends on storage volume and access frequency.
   - CLS cost depends on log volume and index configuration.
   - Use lifecycle rules for long-term COS storage.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks Cloud Config or storage permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check `QcloudConfigFullAccess`, `QcloudCOSFullAccess`, `QcloudCLSFullAccess` are included.

#### Error 2: Bucket already exists

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=Bucket already exists
```

**Cause**: The COS bucket name is already used.
**Solution**:
- Use an existing bucket via `cos_bucket`, or choose a unique new bucket name.

#### Error 3: Invalid CLS configuration

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid CLS configuration
```

**Cause**: A CLS parameter is incorrect.
**Solution**:
- Ensure `cls_period` is within 1-366 days.
- Ensure `cls_partition_count` is within 1-10.
- Verify `cls_storage_type` is `hot` or `cold`.

#### Error 4: Invalid delivery target type

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid deliver target type
```

**Cause**: `deliver_target_type` is not `COS` or `CLS`.
**Solution**:
- Set `deliver_target_type` to `COS` or `CLS`.

#### Error 5: Invalid content type

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid deliver content type
```

**Cause**: `deliver_content_type` is not `1`, `2` or `3`.
**Solution**:
- Set `deliver_content_type` to `1`, `2` or `3`.

## License

See [LICENSE](../../../LICENSE) for full details.
