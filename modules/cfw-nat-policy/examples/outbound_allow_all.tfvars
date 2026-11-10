# Outbound allow all (all ports/protocols) - use with caution
direction = 0
port = "-1"
protocol = "ANY"
rule_action = "accept"
source_content = "net:10.0.0.0/16"
source_type = "net"
target_content = "net:0.0.0.0/0"
target_type = "net"
description = "Allow all outbound traffic for application subnet"
enable = "true"
scope = "ALL"
