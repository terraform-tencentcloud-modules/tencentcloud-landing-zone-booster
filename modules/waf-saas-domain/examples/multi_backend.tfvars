# Multi-backend example (IP list + weighted load balancing)
# Replace instance_id and IPs with real values.

domain = "app.example.com"
instance_id = "waf-instance-xxxx"
ports = [
  {
    port = "80"
    protocol = "http"
    upstream_port = "80"
    upstream_protocol = "http"
  }
]
upstream_type = 0
src_list = ["10.0.1.10", "10.0.1.11"]
weights  = [70, 30]
load_balance = "2" # weighted round-robin
