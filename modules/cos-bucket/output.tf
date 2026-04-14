output "bucket_id" {
  value = tencentcloud_cos_bucket.bucket.id
}

output "bucket_name" {
  value = tencentcloud_cos_bucket.bucket.bucket
}

output "bucket_url" {
  value = tencentcloud_cos_bucket.bucket.cos_bucket_url
}

output "cos_app_id" {
  value = local.app_id
}