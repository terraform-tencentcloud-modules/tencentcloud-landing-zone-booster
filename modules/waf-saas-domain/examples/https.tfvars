# HTTPS example using managed certificate (cert_type = 2)
# Replace instance_id, domain and ssl_id with real values.

domain = "secure.example.com"
instance_id = "waf-instance-xxxx"
ports = [
  {
    port = "443"
    protocol = "https"
    upstream_port = "443"
    upstream_protocol = "https"
  }
]
cert_type = 2
ssl_id    = "managed-cert-xxxx"
is_http2  = 1
https_rewrite = 1
