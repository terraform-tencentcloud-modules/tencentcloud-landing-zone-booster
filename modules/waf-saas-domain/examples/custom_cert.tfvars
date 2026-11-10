# Example using self-owned certificate (cert_type = 1)
# WARNING: cert and private_key are sensitive. Prefer using secure variable storage.

domain = "api.example.com"
instance_id = "waf-instance-xxxx"
ports = [
  {
    port = "443"
    protocol = "https"
    upstream_port = "8443"
    upstream_protocol = "https"
  }
]
cert_type   = 1
cert = <<EOF
-----BEGIN CERTIFICATE-----
# paste PEM certificate here
-----END CERTIFICATE-----
EOF
private_key = <<EOF
-----BEGIN PRIVATE KEY-----
# paste private key here
-----END PRIVATE KEY-----
EOF
sni_type    = 3
sni_host    = "upstream.internal.example.com"
upstream_type = 1
upstream_domain = "upstream.internal.example.com"
