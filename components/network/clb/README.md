# TencentCloud CLB Component for Terraform

Terraform component under `components/network/clb` for creating and managing a Tencent Cloud CLB (Cloud Load Balancer) instance, with optional CLB log set/topic provisioning and SLA configuration. It is part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Features

- Provision a public (`OPEN`) or private (`INTERNAL`) CLB instance.
- Configurable VIP, IP version (`ipv4` / `ipv6` / `IPv6FullChain`), and internet billing mode.
- Optional automatic creation of CLB log set and log topic.
- Optional SLA (LCU-supported) configuration.
- Optional SNAT and security group binding for backend targets.

## Usage

```hcl
module "clb" {
  source = "path/to/components/network/clb"

  clb_instance = {
    # ── Required ──
    clb_name = "example-clb"
    vpc_id   = "vpc-xxxxxxxx"

    # ── Base ──
    network_type             = "OPEN"        # OPEN / INTERNAL
    project_id               = 0
    delete_protect           = false
    tags                     = { Environment = "Production" }

    # ── VIP ──
    dynamic_vip         = false
    address_ip_version  = "ipv4"

    # ── Internet (only for OPEN) ──
    internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
    internet_bandwidth_max_out = 10

    # ── Security groups ──
    security_groups = []

    # ── Backend target ──
    enable_pass_to_target = true

    # ── CLB log ──
    create_clb_log     = true
    clb_log_set_period = 7
    clb_log_topic_name = "clb_topic"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.136 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.136 |

## Inputs

This component accepts a single composite `clb_instance` object.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clb_instance"></a> [clb\_instance](#input\_clb\_instance) | CLB instance configuration. | <pre>object({<br>  # ── Required ──<br>  clb_name = string<br>  vpc_id   = string<br>  # ── Base ──<br>  project_id               = optional(number, 0)<br>  network_type             = optional(string, "OPEN")   # OPEN / INTERNAL<br>  subnet_id                = optional(string)           # Required when network_type = INTERNAL<br>  availability_zone        = optional(string)           # Only for OPEN<br>  master_availability_zone = optional(string)           # Only for OPEN, cross-AZ DR<br>  slave_availability_zone  = optional(string)           # Only for OPEN, cross-AZ DR<br>  delete_protect           = optional(bool, false)<br>  tags                     = optional(map(string), {})<br>  # ── VIP ──<br>  dynamic_vip         = optional(bool)<br>  vip                 = optional(string)<br>  address_ip_version  = optional(string)               # ipv4 / ipv6 / IPv6FullChain, only for OPEN<br>  # ── Internet (only for OPEN) ──<br>  internet_charge_type       = optional(string, "TRAFFIC_POSTPAID_BY_HOUR")<br>  internet_bandwidth_max_out = optional(number, 10)     # Mbps<br>  bandwidth_package_id       = optional(string)         # Required when internet_charge_type = BANDWIDTH_PACKAGE<br>  # ── SLA ──<br>  sla_type = optional(string)                            # Required for LCU-supported instances<br>  # ── Security groups ──<br>  security_groups = optional(list(string), [])<br>  # ── SNAT ──<br>  snat_pro = optional(bool)<br>  snat_ips = optional(list(object({<br>    subnet_id = string<br>    ip        = optional(string)<br>  })), [])<br>  # ── Backend target ──<br>  enable_pass_to_target     = optional(bool, true)<br>  target_region_info_region = optional(string)<br>  target_region_info_vpc_id = optional(string)<br>  # ── CLB log ──<br>  create_clb_log     = optional(bool, false)<br>  log_set_id         = optional(string)<br>  log_topic_id       = optional(string)<br>  clb_log_set_period = optional(number, 7)              # days, max 90<br>  clb_log_topic_name = optional(string, "clb_topic")<br>  # ── Advanced ──<br>  associate_endpoint = optional(string)<br>})</pre> | n/a | yes |

### Validation Rules

- `network_type` must be either `OPEN` or `INTERNAL`.
- `subnet_id` is required when `network_type` is `INTERNAL`.
- `bandwidth_package_id` is required when `internet_charge_type` is `BANDWIDTH_PACKAGE`.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_clb_id"></a> [clb\_id](#output\_clb\_id) | The ID of the clb instance. |
| <a name="output_clb_vips"></a> [clb\_vips](#output\_clb\_vips) | The virtual service address table of the CLB. |
| <a name="output_clb_domain"></a> [clb\_domain](#output\_clb\_domain) | Domain name of the CLB instance. |
| <a name="output_clb_log_set_id"></a> [clb\_log\_set\_id](#output\_clb\_log\_set\_id) | The id of log set. |
| <a name="output_clb_log_topic_id"></a> [clb\_log\_topic\_id](#output\_clb\_log\_topic\_id) | The id of log topic. |

## Notes

- CLB log set/topic are created automatically only when `create_clb_log = true` and the corresponding `log_set_id` / `log_topic_id` are not provided.
- Tags `owner`, `tke-clusterId`, `ccs-clusterId`, and `last-modified` are preserved and ignored on changes (used by external systems such as TKE/CCS for service attaching).
- For public (`OPEN`) CLB, `availability_zone`, `master_availability_zone`, and `slave_availability_zone` support cross-AZ DR.

## License

See [LICENSE](../../../LICENSE) for full details.
