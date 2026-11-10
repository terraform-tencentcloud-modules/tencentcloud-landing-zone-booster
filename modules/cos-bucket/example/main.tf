module "example" {
  source = "../"
  bucket_name = "cos-test"
  cors_rules = [ {
    allowed_headers = [ "*" ]
    allowed_methods = ["PUT", "GET", "POST", "DELETE", "HEAD"]
    allowed_origins = [ "*" ]
    expose_headers  = ["ETag", "Content-Length", "x-cos-request-id"]
    max_age_seconds = 0
  } ]
}