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

module "cfw_nat_fw" {
  source = "../../../../../components/security/cfw/fw-nat"

  mode = 1
  name = "cfw-nat-fw"
  width = 100
  zone_set = ["ap-shanghai-5", "ap-shanghai-8"]
  cross_a_zone = 0
  nat_gw_list = ["nat-00000001"]
  new_mode_items = []

  switches = [
    {
      enable = 1
      subnet_id = "subnet-xxxx"
    }
  ]

  inbound_policies = [
    {
      # Rule status, true means enabled, false means disabled. Default is true.
      enable         = "true"
      # The port for the access control policy. Value: -1/-1: All ports 80: Port 80.
      port           = "80,443"
      # "Protocol. If Direction=1, optional values: TCP, UDP, ANY; If Direction=0, optional values: TCP, UDP, ICMP, ANY, HTTP, HTTPS, HTTP/HTTPS, SMTP, SMTPS, SMTP/SMTPS, FTP, and DNS.
      protocol       = "TCP"
      # How the traffic set in the access control policy passes through the cloud firewall. Values: accept: allow; drop: reject; log: observe.
      rule_action    = "accept"
      # Access source example: net:IP/CIDR(192.168.0.2).
      source_content = "0.0.0.0/0"
      # Access source type: for inbound rules, the type can be net, location, vendor, template; for outbound rules, it can be net, instance, tag, template, group.
      source_type    = "net"
      # Example of access purpose: net: IP/CIDR(192.168.0.2) domain: domain name rules, such as *.qq.com.
      target_content = "10.222.252.0/22"
      # Access purpose type: For inbound rules, the type can be net, instance, tag, template, group; for outbound rules, it can be net, location, vendor, template.
      target_type    = "net"
      # Description.
      description    = "Allow HTTP from all network"
      # Scope of effective rules. ALL: Global effectiveness; ap-guangzhou: Effective territory; cfwnat-xxx: Effectiveness based on instance dimension.
      scope          = "ALL"
    }
  ]
  outbound_policies = [
    {
      enable         = "true"
      port           = "80,443"
      protocol       = "TCP"
      rule_action    = "accept"
      source_content = "0.0.0.0/0"
      source_type    = "net"
      target_content = "10.222.252.0/22"
      target_type    = "net"
      description    = "Allow HTTP from all network"
      scope          = "ALL"
    }
  ]
}