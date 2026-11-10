terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.125"
    }
  }
}

provider "tencentcloud" {
  region = "ap-shanghai"
}

module "cfw_edge_fw" {
  source = "../../../../../components/security/cfw/fw-edge"

  switches = [
    {
      switch_enable      = 1
      switch_mode        = 1
      switch_public_addr = "10.0.0.100"
      switch_subnet_id   = "subnet-xxxxx"
    }
  ]

  inbound_policies = [{
    # Rule status, true means enabled, false means disabled. Default is true.
    enable         = "true"
    # Access source example: net:IP/CIDR(192.168.0.2).
    source_content = "0.0.0.0/0"
    # Access source type: for inbound rules, the type can be net, location, vendor, template; for outbound rules, it can be net, instance, tag, template, group.
    source_type    = "net"
    # Example of access purpose: net: IP/CIDR(192.168.0.2) domain: domain name rules, such as *.qq.com.
    target_content = "0.0.0.0/0"
    # Access purpose type: For inbound rules, the type can be net, instance, tag, template, group; for outbound rules, it can be net, location, vendor, template.
    target_type    = "instance"
    # The port for the access control policy. Value: -1/-1: All ports 80: Port 80.
    port           = ""
    # Protocol.
    # If Direction=1 && Scope=serial, optional values: TCP UDP ICMP ANY HTTP HTTPS HTTP/HTTPS SMTP SMTPS SMTP/SMTPS FTP DNS;
    # If Direction=1 && Scope!=serial, optional values: TCP;
    # If Direction=0 && Scope=serial, optional values: TCP UDP ICMP ANY HTTP HTTPS HTTP/HTTPS SMTP SMTPS SMTP/SMTPS FTP DNS;
    # If Direction=0 && Scope!=serial, optional values: TCP HTTP/HTTPS TLS/SSL.
    protocol       = "ICMP"
    # How the traffic set in the access control policy passes through the cloud firewall. Values: accept: allow; drop: reject; log: observe.
    rule_action    = "accept"
    # Description.
    description    = "Allow All ICMP"
    # Effective range. serial: serial; side: bypass; all: global, Default is all.
    scope          = "serial"
  }]
  outbound_policies = []
}