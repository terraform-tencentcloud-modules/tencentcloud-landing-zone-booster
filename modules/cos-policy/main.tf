#Provides a COS resource to create a COS bucket policy and set its attributes.
resource "tencentcloud_cos_bucket_policy" "cos_bucket_policy" {
  bucket = var.cos_bucket_name
  policy = var.cos_bucket_policy
}