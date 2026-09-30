# TencentCloud COS Bucket Module for Terraform

## terraform-tencentcloud-cos-bucket

A terraform module that creates a TencentCloud COS (Cloud Object Storage) bucket (`tencentcloud_cos_bucket`). It supports access control, versioning, server-side encryption (AES256 / KMS / SM4), lifecycle rules, CORS rules, origin-pull rules, access logging and tags. The bucket name is suffixed automatically with the account `app_id` (`${bucket_name}-${app_id}`).

## Usage

```hcl
module "cos_bucket" {
  source = "terraform-tencentcloud-modules/cos-bucket/tencentcloud"

  bucket_name           = "mycos"
  bucket_acl            = "private"
  versioning_enable     = true
  encryption_algorithm  = "AES256"
  multi_az              = false

  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
      allowed_origins = ["*"]
      expose_headers  = ["ETag", "Content-Length", "x-cos-request-id"]
      max_age_seconds = 0
    }
  ]

  tags = {
    created_by = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app_id | Your appid. If empty, it is resolved automatically from the current account. | string | "" | no |
| bucket_name | The name of the bucket (without the `-appid` suffix). | string | "mycos" | no |
| bucket_acl | Access control list for the bucket. | string | "private" | no |
| multi_az | Indicates whether to create a bucket of multi available zone. NOTE: If set to true, versioning must be enabled. | bool | false | no |
| force_clean | Whether to force cleanup all objects before deleting the bucket. | bool | false | no |
| versioning_enable | Enable bucket versioning. | bool | false | no |
| encryption_algorithm | The server-side encryption algorithm to use. Valid values are `AES256`, `KMS` and `SM4`. | string | null | no |
| kms_id | The KMS Master Key ID. Valid only when `encryption_algorithm` is `KMS`. If not specified, the default KMS id is used. | string | null | no |
| lifecycle_rules | List of lifecycle rules configuration. Each rule may contain `id`, `filter_prefix`, `expiration`, `transition`, `non_current_expiration`, `non_current_transition` and `abort_incomplete_multipart_upload`. | list(object) | [] | no |
| cors_rules | A rule of Cross-Origin Resource Sharing. | list(object({ allowed_headers = list(string), allowed_methods = list(string), allowed_origins = list(string), expose_headers = optional(list(string), ["ETag", "Content-Length", "x-cos-request-id"]), max_age_seconds = optional(number, 0) })) | [] | no |
| origin_pull_rules | Bucket Origin-Pull settings. | list(object({ host = string, priority = string, back_to_source_mode = optional(string), custom_http_headers = optional(map(string)), follow_http_headers = optional(set(string)), follow_query_string = optional(bool), follow_redirection = optional(bool), http_redirect_code = optional(string), prefix = optional(string), protocol = optional(string) })) | [] | no |
| log_enable | Indicate the access log of this bucket to be saved or not. | bool | false | no |
| log_prefix | The prefix log name which saves the access log of this bucket per 5 minutes. Only valid when `log_enable` is true. | string | "" | no |
| log_target_bucket | The target bucket name which saves the access log of this bucket per 5 minutes. User must have full access on this bucket. Only valid when `log_enable` is true. | string | "" | no |
| tags | A mapping of tags to assign to the bucket. | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The ID of the COS bucket. |
| bucket_name | The full bucket name (including the `-appid` suffix). |
| bucket_url | The URL of the COS bucket. |
| cos_app_id | The app_id used by the bucket. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-cos-bucket)

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
