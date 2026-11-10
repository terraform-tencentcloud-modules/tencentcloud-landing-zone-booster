# Basic example: HTTP domain
# Replace the instance_id and domain with real values before apply.

domain = "example.com"
instance_id = "waf-instance-xxxx"
ports = [
  {
    port = "80"
    protocol = "http"
    upstream_port = "80"
    upstream_protocol = "http"
  }
]
