# Inbound drop single malicious IP
direction = 1
port = "443"
protocol = "TCP"
rule_action = "drop"
source_content = "net:203.0.113.5"
source_type = "net"
target_content = "net:10.0.0.5"
target_type = "net"
description = "Block malicious IP"
enable = "true"
scope = "ALL"
