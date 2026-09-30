# Tencent Cloud CloudAudit Management Component

Terraform component under `components/audit-log/cloud-audit` for creating and managing CloudAudit tracks in Tencent Cloud. It is part of the `audit-log` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages CloudAudit tracks that record cloud resource operation logs, with support for:

- **Track creation** – create a CloudAudit track that records cloud resource operation logs.
- **Multiple storage types** – support COS object storage, CLS log service and CKafka as storage backends.
- **Organization-wide audit** – support auditing of all members in an organization.
- **Fine-grained filtering** – filter by resource type, action type and event names.
- **Automatic policy configuration** – automatically configure the required access policy for the storage resource.
- **Lifecycle management** – configure lifecycle rules for the storage resource (COS).

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
| `QcloudAuditFullAccess` | Full access to CloudAudit |
| `QcloudCOSFullAccess` | Full access to COS |
| `QcloudCLSFullAccess` | Full access to CLS |

### Prerequisites

- The current account must have CloudAudit management permissions.
- A Tencent Cloud Organization must be created in advance if organization-wide audit is used.
- The storage region must match the CloudAudit track region.

---

## Inputs

### Common configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_create_cam_strategy"></a> [create\_cam\_strategy](#input\_create\_cam\_strategy) | `bool` | `false` | Whether to create the CAM role and the relative essential policy. Set to `false` if already enabled via the Tencent Cloud Console. |
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | `string` | `null` | Organization App ID. |
| <a name="input_account_uin"></a> [account\_uin](#input\_account\_uin) | `string` | `null` | Organization member name or UIN to audit. |
| <a name="input_tags"></a> [tags](#input\_tags) | `map(string)` | `null` | Tags applied to resources. |

### CloudAudit track configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| <a name="input_cloudaudit_action_type"></a> [cloudaudit\_action\_type](#input\_cloudaudit\_action\_type) | `string` | `"*"` | Track interface type: `Read`, `Write`, or `*`. |
| <a name="input_cloudaudit_resource_type"></a> [cloudaudit\_resource\_type](#input\_cloudaudit\_resource\_type) | `string` | `"*"` | Track product: `*` for all products, or a single product such as `cos`. |
| <a name="input_cloudaudit_event_names"></a> [cloudaudit\_event\_names](#input\_cloudaudit\_event\_names) | `list(string)` | `["*"]` | Track interface name list. When `resource_type = "*"`, `event_names` must be `["*"]`; when `resource_type` is a single product, up to 10 interfaces are allowed. |
| <a name="input_cloudaudit_track_name"></a> [cloudaudit\_track\_name](#input\_cloudaudit\_track\_name) | `string` | `"track_audit"` | CloudAudit track name. |
| <a name="input_cloudaudit_track_for_all_members"></a> [cloudaudit\_track\_for\_all\_members](#input\_cloudaudit\_track\_for\_all\_members) | `number` | `1` | Whether to audit all organization members (`0` = no, `1` = yes). |
| <a name="input_cloudaudit_track_status"></a> [cloudaudit\_track\_status](#input\_cloudaudit\_track\_status) | `number` | `1` | Track status (`0` = closed, `1` = open). |
| <a name="input_cloudaudit_storage_type"></a> [cloudaudit\_storage\_type](#input\_cloudaudit\_storage\_type) | `string` | - (required) | Storage type: `cos`, `cls` or `ckafka`. |
| <a name="input_cloudaudit_storage_region"></a> [cloudaudit\_storage\_region](#input\_cloudaudit\_storage\_region) | `string` | - (required) | CloudAudit storage region. |
| <a name="input_cloudaudit_storage_name"></a> [cloudaudit\_storage\_name](#input\_cloudaudit\_storage\_name) | `string` | - (required) | CloudAudit storage name. |
| <a name="input_cloudaudit_storage_prefix"></a> [cloudaudit\_storage\_prefix](#input\_cloudaudit\_storage\_prefix) | `string` | - (required) | CloudAudit storage prefix. |

### COS storage configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
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
| <a name="input_cls_logset_name"></a> [cls\_logset\_name](#input\_cls\_logset\_name) | `string` | - (required) | CLS logset name. |
| <a name="input_cls_logset_tags"></a> [cls\_logset\_tags](#input\_cls\_logset\_tags) | `map(string)` | `null` | Logset tags. |
| <a name="input_cls_topic_name"></a> [cls\_topic\_name](#input\_cls\_topic\_name) | `string` | - (required) | CLS topic name. |
| <a name="input_cls_auto_split"></a> [cls\_auto\_split](#input\_cls\_auto\_split) | `bool` | `true` | Whether to enable automatic split. |
| <a name="input_cls_max_split_partitions"></a> [cls\_max\_split\_partitions](#input\_cls\_max\_split\_partitions) | `number` | `50` | Max partitions to split into when auto-split is enabled. |
| <a name="input_cls_partition_count"></a> [cls\_partition\_count](#input\_cls\_partition\_count) | `number` | `1` | Number of topic partitions (1-10). |
| <a name="input_cls_period"></a> [cls\_period](#input\_cls\_period) | `number` | `30` | Lifecycle in days (1-366). |
| <a name="input_cls_storage_type"></a> [cls\_storage\_type](#input\_cls\_storage\_type) | `string` | `"hot"` | Topic storage class: `hot` (real-time) or `cold` (offline). |
| <a name="input_cls_describes"></a> [cls\_describes](#input\_cls\_describes) | `string` | `null` | Topic description. |
| <a name="input_cls_hot_period"></a> [cls\_hot\_period](#input\_cls\_hot\_period) | `number` | `null` | Log sinking standard-storage days (`0` = disabled). |
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
| <a name="output_cloudaudit_id"></a> [cloudaudit\_id](#output\_cloudaudit\_id) | The ID of the CloudAudit track. |
| <a name="output_cos_bucket"></a> [cos\_bucket](#output\_cos\_bucket) | The COS bucket name (when `storage_type = "cos"`). |
| <a name="output_cos_bucket_url"></a> [cos\_bucket\_url](#output\_cos\_bucket\_url) | The COS bucket URL (when `storage_type = "cos"`). |
| <a name="output_logset_id"></a> [logset\_id](#output\_logset\_id) | The CLS logset ID (when `storage_type = "cls"`). |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | The CLS topic ID (when `storage_type = "cls"`). |
| <a name="output_index_id"></a> [index\_id](#output\_index\_id) | The CLS index ID (when `storage_type = "cls"` and `cls_create_index = true`). |

---

## Configuration Examples

### `terraform.tfvars` example (COS)

```hcl
# Required
cloudaudit_storage_region = "ap-guangzhou"
cloudaudit_storage_type   = "cos"
cloudaudit_storage_name   = "prod-audit-logs"
cloudaudit_storage_prefix = "audit"

cloudaudit_track_name            = "prod-audit-track"
cloudaudit_track_for_all_members = 1
cloudaudit_track_status          = 1

# Fine-grained filter (split into three variables)
cloudaudit_resource_type = "*"
cloudaudit_action_type   = "write"
cloudaudit_event_names   = ["CreateUser", "DeleteUser", "AttachUserPolicy"]

# COS storage configuration
cos_bucket_acl        = "private"
cos_multi_az          = true
cos_force_clean       = true
cos_versioning_enable = true

# COS lifecycle rules
cos_lifecycle_rules = [
  {
    id            = "transition-to-ia"
    filter_prefix = ""

    transition = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
      {
        days          = 60
        storage_class = "ARCHIVE"
      }
    ]
  },
  {
    id            = "expire-old-versions"
    filter_prefix = ""

    non_current_expiration = {
      non_current_days = 90
    }
  }
]
```

### `terraform.tfvars` example (CLS)

```hcl
# Required
cloudaudit_storage_region = "ap-guangzhou"
cloudaudit_storage_type   = "cls"
cloudaudit_storage_name   = "audit-log"
cloudaudit_storage_prefix = "alog"

cloudaudit_track_name            = "detailed-audit-track"
cloudaudit_track_for_all_members = 0  # audit a specific member only
account_uin                      = "100000000001" # member UIN or name

# CLS configuration
cls_logset_name = "security-audit"
cls_topic_name  = "admin-operations"
cls_period      = 180
cls_storage_type = "hot"
cls_create_index = true
```

---

## Usage Examples

### Example 1: Basic COS storage audit

```hcl
module "cloud_audit_cos" {
  source = "./modules/cloud-audit"

  cloudaudit_storage_region = "ap-guangzhou"
  cloudaudit_storage_type   = "cos"
  cloudaudit_storage_name   = "basic-audit-logs"
  cloudaudit_storage_prefix = "audit"

  cloudaudit_track_name            = "basic-audit-track"
  cloudaudit_track_for_all_members = 1

  cloudaudit_resource_type = "*"
  cloudaudit_action_type   = "write"
  cloudaudit_event_names   = ["*"]
}
```

### Example 2: Fine-grained CLS storage audit

```hcl
module "cloud_audit_cls" {
  source = "./modules/cloud-audit"

  cloudaudit_storage_region = "ap-beijing"
  cloudaudit_storage_type   = "cls"
  cloudaudit_storage_name   = "audit-log"
  cloudaudit_storage_prefix = "alog"

  cloudaudit_track_name            = "detailed-audit-track"
  cloudaudit_track_for_all_members = 0  # specific member only
  account_uin                      = "admin-user"

  cls_logset_name = "security-audit"
  cls_topic_name  = "admin-operations"
  cls_period      = 180
  cls_storage_type = "hot"

  cloudaudit_resource_type = "cam"
  cloudaudit_action_type   = "*"
  cloudaudit_event_names   = ["*User*", "*Policy*", "*Role*"]
}
```

### Example 3: Full production configuration

```hcl
module "cloud_audit_prod" {
  source = "./modules/cloud-audit"

  cloudaudit_storage_region = "ap-shanghai"
  cloudaudit_storage_type   = "cos"
  cloudaudit_storage_name   = "prod-audit"
  cloudaudit_storage_prefix = "audit"

  cloudaudit_track_name            = "production-audit"
  cloudaudit_track_for_all_members = 1
  cloudaudit_track_status          = 1

  cos_multi_az          = true
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

  cloudaudit_resource_type = "*"
  cloudaudit_action_type   = "*"
  cloudaudit_event_names   = ["*"]
}
```

### Example 4: Compliance audit (CLS + index)

```hcl
module "cloud_audit_compliance" {
  source = "./modules/cloud-audit"

  cloudaudit_storage_region = "ap-guangzhou"
  cloudaudit_storage_type   = "cls"
  cloudaudit_storage_name   = "compliance-log"
  cloudaudit_storage_prefix = "alog"

  cloudaudit_track_name            = "compliance-audit"
  cloudaudit_track_for_all_members = 1

  cls_logset_name  = "compliance-logs"
  cls_topic_name   = "security-events"
  cls_period       = 365
  cls_create_index = true

  cloudaudit_resource_type = "cam"
  cloudaudit_action_type   = "write"
  cloudaudit_event_names   = ["CreateUser", "DeleteUser", "CreatePolicy", "AttachUserPolicy"]
}
```

---

## Configuration Notes

### Storage type selection

```
Storage type selection:
┌──────────────────────────────────────────────┐
│  Check cloudaudit_storage_type                │
│         │                                      │
│  "cos"    → create a COS bucket                │
│  "cls"    → create a CLS logset/topic          │
│  "ckafka" → deliver to a CKafka instance       │
└──────────────────────────────────────────────┘
```

### Module dependencies

```
tencentcloud_audit_track.track (create track)
          │
          ├─ COS storage (optional, storage_type = "cos")
          │     └─ COS bucket policy (optional)
          │
          └─ CLS storage (optional, storage_type = "cls")
                └─ CLS index (optional, cls_create_index = true)
```

### Audit filter syntax

The filter is configured via three separate variables:

| Variable | Meaning | Example |
|----------|---------|---------|
| `cloudaudit_resource_type` | Product to track (`*` = all, or a single product) | `"cam"` |
| `cloudaudit_action_type` | Interface type: `Read` / `Write` / `*` | `"write"` |
| `cloudaudit_event_names` | Interface name list, wildcards supported | `["CreateUser"]` |

> When `resource_type = "*"`, `event_names` must be `["*"]`.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Storage region consistency**
   - The storage region must match the CloudAudit track region.
   - Cross-region storage requires additional cross-region replication.

2. **Organization member audit**
   - With `cloudaudit_track_for_all_members = 1`, all organization members are audited.
   - A Tencent Cloud Organization must be created in advance. Use `account_uin` to audit a specific member (only effective when `for_all_members = 0`).

3. **Storage type**
   - Supported storage types are `cos`, `cls` and `ckafka`.
   - `cloudaudit_storage_type` has no default and must be set explicitly.

4. **COS access policy**
   - The module automatically configures CloudAudit service access for the COS bucket.
   - Manually modifying the policy may break auditing.

5. **CLS index**
   - With `cls_create_index = true`, the index is created automatically.
   - Configure `cls_rules` carefully per your audit needs. Only one rule block is allowed.

6. **Audit data volume**
   - Full auditing (`resource_type = "*"`, `event_names = ["*"]`) produces a large volume of logs.
   - Configure filters according to your actual needs.

7. **Cost considerations**
   - COS cost depends on storage volume and access frequency.
   - CLS cost depends on log volume and index configuration.
   - Use lifecycle rules for long-term COS storage.

8. **Compliance**
   - Audit logs must meet compliance retention requirements.
   - Sensitive operations should be retained longer.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks CloudAudit or storage permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check `QcloudAuditFullAccess`, `QcloudCOSFullAccess`, `QcloudCLSFullAccess` are included.

#### Error 2: Region mismatch

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Region does not match
```

**Cause**: The storage region does not match the track region.
**Solution**:
- Ensure `cloudaudit_storage_region` matches the track region.
- Check Tencent Cloud region availability.

#### Error 3: Bucket already exists

```
Error: [TencentCloudSDKError] Code=ResourceInUse
Message=Bucket already exists
```

**Cause**: The COS bucket name is already used.
**Solution**:
- Change `cloudaudit_storage_name` to a unique name.
- Delete the existing bucket with the same name.

#### Error 4: Member not found

```
Error: [TencentCloudSDKError] Code=ResourceNotFound
Message=Member not found
```

**Cause**: The specified organization member does not exist.
**Solution**:
- Confirm the member UIN or name (`account_uin`) is correct.
- Check the Tencent Cloud Organization structure.

#### Error 5: Invalid CLS configuration

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid CLS configuration
```

**Cause**: A CLS parameter is incorrect.
**Solution**:
- Ensure `cls_period` is within 1-366 days.
- Ensure `cls_partition_count` is within 1-10.
- Verify `cls_storage_type` is `hot` or `cold`.

#### Error 6: Invalid audit filter

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid audit filter
```

**Cause**: The audit filter format is incorrect.
**Solution**:
- Check the three filter variables (`cloudaudit_resource_type`, `cloudaudit_action_type`, `cloudaudit_event_names`).
- When `resource_type = "*"`, `event_names` must be `["*"]`.
- Use resource types and event names supported by Tencent Cloud.

## License

See [LICENSE](../../../LICENSE) for full details.
