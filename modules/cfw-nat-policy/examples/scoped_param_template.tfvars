# Scoped rule with param_template_id example
direction = 1
port = "22"
protocol = "TCP"
rule_action = "log"
source_content = "net:198.51.100.0/24"
source_type = "net"
target_content = "net:10.0.2.0/24"
target_type = "net"
description = "SSH monitoring for specific region"
enable = "true"
param_template_id = "tmpl-EXAMPLE-1234"
scope = "ap-guangzhou"
