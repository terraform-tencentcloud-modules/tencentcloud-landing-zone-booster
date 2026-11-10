# Inbound allow HTTP (port 80) from a source network to a target network
direction = 1
port = "-1/-1"
protocol = "ANY"
rule_action = "accept"
source_content = "mb_1328140161_1765163982869"
source_type = "template"
target_content = "net:10.0.0.0/16"
target_type = "net"
description = "Allow HTTP from corporate network"
enable = "true"
scope = "ALL"
