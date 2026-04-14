# TencentCloud CloudAudit Module for Terraform 

## terraform-tencentcloud-cloudaudit

A terraform module that creates CloudAudit Track and saves events to your COS bucket.


## Usage

```hcl
provider "tencentcloud" {
  region = var.region
}

locals {
  account_id = "your account id"
  bucket_name = "your bucket name"
  appid = "your appid"
  bucket = "${local.bucket_name}-${local.appid}"
}

module "cloud_audit" {
  source = "terraform-tencentcloud-modules/cloudaudit/tencentcloud"

  create_track = true
  create_bucket = true
  create_bucket_policy = true

  track_name = "tfmodule_audit"
  bucket_name = local.bucket_name
  appid = local.appid
  storage_prefix = "tfmodule"
  region = var.region
  
  force_clean = true
  versioning_enable = true

  lifecycle_rules = [
    {
      filter_prefix = "tf"
      transition = [{
        days = 100
        storage_class = "STANDARD_IA"
      }]
    }
  ]

  policy = <<EOF
    {
      "version": "2.0",
      "Statement": [
        {
          "Principal": {
            "qcs": [
              "qcs::cam::uin/${local.account_id}:uin/${local.account_id}"
            ]
          },
          "Action": [
            "name/cos:DeleteBucket",
            "name/cos:PutBucketACL"
          ],
          "Effect": "allow",
          "Resource": [
            "qcs::cos:${var.region}:uid/${local.appid}:${local.bucket}/*"
          ]
        }
      ]
    }
  EOF
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_track | Controls if cloud audit track should be created. | bool | true | no |
| create_bucket | Controls if COS bucket should be created. | bool | false | no |
| create_bucket_policy | Controls if COS bucket policy should be created. | bool | false | no |
| track_name | The name of cloud audit track. | string | "" | yes |
| action_type | Track interface type, optional: (Read: Read interface, Write: Write interface, *: All interface),  Default is *. | string | * | no |
| resource_type | Track product, optional: (*: All product, Single product, such as cos), Default is *. | string | * | no |
| event_names | Track interface name list. When resource_type is *, event_names is must *; When resource_type is a single product, event_name support all interfaces and some interfaces, up to 10. | string | [ " * "] | no |
| status | Track status, optional: (close: 0, open: 1). Default is 1. | number | 1 | no |
| bucket_name | The name of the bucket. | string | "" | yes |
| appid | Your appid. | string | "" | yes |
| storage_prefix | Storage path prefix. | string | "" | yes |
| region | The region of storage. | string | ap-singapore | no |
| storage_type | Track Storage type, optional: cos or cls. | string | cos | no |
| track_for_all_members | Whether to enable the delivery of group member operation logs to the group management account or trusted service management account, optional: (close: 0, open: 1). | number | 0 | no |
| bucket_acl | Access control list for the bucket. | string | private | no |
| acl_body | The XML format of Access control list for the bucket. | string | null | no |
| encryption_algorithm | The server-side encryption algorithm to the bucket. | string | AES256 | no |
| force_clean | Whether to force cleanup all objects before delete bucket. | bool | false | no |
| versioning_enable | Enable bucket versioning. | bool | false | no |
| log_enable | Indicate the access log of this bucket to be saved or not. | bool | false | no |
| log_prefix | The prefix log name which saves the access log of this bucket per 5 minutes. Eg. MyLogPrefix/. The log access file format is log_target_bucket/log_prefix{YYYY}/{MM}/{DD}/{time}{random}{index}.gz. Only valid when log_enable is true." | string | "" | no |
| log_target_bucket | The target bucket name which saves the access log of this bucket per 5 minutes. The log access file format is log_target_bucket/log_prefix{YYYY}/{MM}/{DD}/{time}{random}{index}.gz. Only valid when log_enable is true. User must have full access on this bucket.| string | "" | no |
| lifecycle_rules | Lifecycle rules to the bucket. | list | [] | no |
| tags | A mapping of tags to assign to the bucket. | map | {} | no |
| policy | The text of the policy. | string | "" | no |



## Outputs

| Name | Description |
|------|-------------|
| cloudaudit_id | The ID of Cloud Audit Track. | 
| bucket_id | The ID of COS bucket. |
| bucket_policy_id | The ID of COS bucket Policy. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-vpc)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.

