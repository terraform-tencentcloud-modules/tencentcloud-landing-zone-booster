# Inbound allow HTTP (port 80) from a source network to a target network
direction = 1
port = "80"
protocol = "TCP"
rule_action = "accept"
source_content = "net:192.0.2.0/24"
source_type = "net"
target_content = "net:10.0.0.0/16"
target_type = "net"
description = "Allow HTTP from corporate network"
enable = "true"
scope = "ALL"
