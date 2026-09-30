# Tencent Cloud CCN Component

Terraform component under `components/network/ccn` for creating and managing CCN (Cloud Connect Network) instances in Tencent Cloud. It enables cross-region and cross-VPC network interconnection as part of the `network` building block of the tencentcloud-landing-zone-booster framework.

## Overview

This component creates and manages a Cloud Connect Network instance and its associated resources. Main features:

- **CCN instance creation** – create a CCN instance for cross-region network interconnection.
- **Billing & QoS control** – choose billing mode (`PREPAID`/`POSTPAID`) and service quality (`PT`/`AU`/`AG`).
- **Route tables** – create CCN route tables and associate them with attachments.
- **Route policies** – configure input and broadcast policies based on instance type, region, ID, or CIDR.
- **ECMP / overlap routing** – enable equivalent-cost multipath and route overlap functions.
- **Cross-account attachments** – initiate attachments, and accept/reject/reset cross-account attachment requests.
- **Tag management** – attach tags to the CCN instance.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >= 1.81.125 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >= 1.81.125 |

### IAM Permissions

The executing principal needs the following Tencent Cloud permissions:

| Permission | Description |
|------------|-------------|
| `QcloudCCNFullAccess` | Full access to CCN management |
| `QcloudTagFullAccess` | Full access to Tag management |
| `QcloudVPCFullAccess` | Full access to VPC management (required for VPC attachments) |

### Prerequisites

- Plan the CCN interconnection strategy (which VPCs/regions to connect).
- Understand cross-region bandwidth requirements.
- Decide billing mode and service quality requirements.
- Plan the CCN instance name and description (≤ 60 bytes / ≤ 100 bytes respectively).
- For cross-account attachments, obtain the CCN UIN of the owner account.

---

## Inputs

### CCN instance

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ccn_instance"></a> [ccn\_instance](#input\_ccn\_instance) | `object` | yes | – | CCN instance configuration. |
| `↳ name` | `string` | yes | – | CCN instance name (max 60 bytes). |
| `↳ desc` | `string` | no | `"The CCN instance created by Terraform."` | CCN instance description (max 100 bytes). |
| `↳ qos` | `string` | no | `"AU"` | Service quality: `PT` (Platinum), `AU` (Gold), `AG` (Silver). |
| `↳ charge_type` | `string` | no | `"POSTPAID"` | Billing type: `PREPAID`, `POSTPAID`. |
| `↳ bandwidth_limit_type` | `string` | no | `"INTER_REGION_LIMIT"` | Bandwidth limit type: `INTER_REGION_LIMIT` (limit between two regions) or `OUTER_REGION_LIMIT` (limit from a region to all others). |
| `↳ enable_route_ecmp` | `bool` | no | `false` | Whether to enable the equivalent routing (ECMP) function. |
| `↳ enable_route_overlap` | `bool` | no | `true` | Whether to enable the route overlap function. Defaults to `true` and cannot be set to `false`. |
| `↳ instance_metering_type` | `string` | no | `"BANDWIDTH"` | Billing mode of the instance: `BANDWIDTH` (billed by bandwidth) or `TRAFFIC` (billed by traffic). |
| `↳ tags` | `map(string)` | no | `{}` | Tags of the CCN instance. |

### CCN route tables

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ccn_route_tables"></a> [ccn\_route\_tables](#input\_ccn\_route\_tables) | `map(object)` | no | `{}` | CCN route tables, keyed by a logical name. |
| `↳ name` | `string` | yes | – | Route table name. |
| `↳ desc` | `string` | yes | – | Route table description. |

### CCN route table input policies

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ccnrt_input_policies"></a> [ccnrt\_input\_policies](#input\_ccnrt\_input\_policies) | `map(object)` | no | `{}` | Input (route receiving) policies per route table. |
| `↳ route_table_name` | `string` | yes | – | Name of the target CCN route table. |
| `↳ policies` | `list(object)` | yes | – | List of policies. |
| `↳↳ action` | `string` | yes | – | Routing behavior: `accept` or `drop`. |
| `↳↳ desc` | `string` | yes | – | Policy description. |
| `↳↳ route_conditions` | `list(object)` | yes | – | Conditions that match incoming routes. |
| `↳↳↳ name` | `string` | yes | – | Condition type: `instance-type`, `instance-region`, `instance-id`, `cidr-block`. |
| `↳↳↳ values` | `set(string)` | yes | – | Conditional values, e.g. `instance-type`: `VPC`,`VPNGW`,`DIRECTCONNECT`; `instance-region`: `ap-guangzhou`; `instance-id`: `vpc-xxx`; `cidr-block`: `172.0.0.0/8`. |
| `↳↳↳ match_pattern` | `number` | yes | – | Matching mode: `1` (precise), `0` (fuzzy). |

### CCN route table broadcast policies

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ccnrt_broadcast_policies"></a> [ccnrt\_broadcast\_policies](#input\_ccnrt\_broadcast\_policies) | `map(object)` | no | `{}` | Broadcast (route advertising) policies per route table. |
| `↳ route_table_name` | `string` | yes | – | Name of the target CCN route table. |
| `↳ policies` | `list(object)` | yes | – | List of policies. |
| `↳↳ action` | `string` | yes | – | Routing behavior: `accept` or `drop`. |
| `↳↳ desc` | `string` | yes | – | Policy description. |
| `↳↳ route_conditions` | `list(object)` | yes | – | Conditions matching the source routes (same schema as input policies). |
| `↳↳ broadcast_conditions` | `list(object)` | yes | – | Conditions matching the destinations to broadcast to (same schema as route_conditions). |

### CCN attachments (initiate)

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ccn_attachments"></a> [ccn\_attachments](#input\_ccn\_attachments) | `list(object)` | no | `[]` | Create CCN attachments. Set to `[]` to skip. |
| `↳ ccn_id` | `string` | yes | – | CCN instance ID. |
| `↳ ccn_uin` | `string` | yes | – | CCN instance UIN. |
| `↳ instance_id` | `string` | yes | – | Network instance ID (VPC ID, VPN Gateway ID, etc.). |
| `↳ instance_region` | `string` | yes | – | Network instance region. |
| `↳ instance_type` | `string` | yes | – | Type: `VPC`, `VPNGW`, `DIRECTCONNECT`, `BMVPC`, `EDGE`. |
| `↳ description` | `string` | no | `""` | Description of the attachment. |
| `↳ route_table_id` | `string` | no | – | CCN route table ID to associate with. |
| `↳ route_table_name` | `string` | no | – | CCN route table name to associate with. |

### Cross-account attachment accept / reject / reset

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ccn_accept_attachments"></a> [ccn\_accept\_attachments](#input\_ccn\_accept\_attachments) | `list(object)` | no | `[]` | Accept cross-account attachment requests. Set to `[]` to skip. |
| <a name="input_ccn_reject_attachments"></a> [ccn\_reject\_attachments](#input\_ccn\_reject\_attachments) | `list(object)` | no | `[]` | Reject cross-account attachment requests. Set to `[]` to skip. |
| <a name="input_ccn_reset_attachments"></a> [ccn\_reset\_attachments](#input\_ccn\_reset\_attachments) | `list(object)` | no | `[]` | Reset attachment state back to pending. Set to `[]` to skip. |
| Each object contains | – | – | – | `ccn_id` (req), `instance_id` (req), `instance_type` (req, one of `VPC`/`VPNGW`/`DIRECTCONNECT`/`BMVPC`/`EDGE`), `instance_region` (req), `description` (opt, `""`), and for reset/`ccn_attachments` also `ccn_uin` (req). |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ccn_id"></a> [ccn\_id](#output\_ccn\_id) | The ID of the CCN instance. |
| <a name="output_ccn_name"></a> [ccn\_name](#output\_ccn\_name) | The name of the CCN instance. |
| <a name="output_ccn_state"></a> [ccn\_state](#output\_ccn\_state) | The state of the CCN instance. |
| <a name="output_ccn_instance_metering_type"></a> [ccn\_instance\_metering\_type](#output\_ccn\_instance\_metering\_type) | Billing mode of the CCN instance (`BANDWIDTH` or `TRAFFIC`). |
| <a name="output_ccn_route_table_ids"></a> [ccn\_route\_table\_ids](#output\_ccn\_route\_table\_ids) | The IDs of CCN route tables (map of route table name => ID). |
| <a name="output_ccn_attached_instance_ids"></a> [ccn\_attached\_instance\_ids](#output\_ccn\_attached\_instance\_ids) | The IDs of attached network instances. |
| <a name="output_ccn_accepted_attachments"></a> [ccn\_accepted\_attachments](#output\_ccn\_accepted\_attachments) | The keys of all accepted cross-account attachments. |
| <a name="output_ccn_rejected_attachments"></a> [ccn\_rejected\_attachments](#output\_ccn\_rejected\_attachments) | The keys of all rejected cross-account attachments. |
| <a name="output_ccn_reset_attachments"></a> [ccn\_reset\_attachments](#output\_ccn\_reset\_attachments) | The keys of all reset cross-account attachments. |

---

## Configuration Examples

### `terraform.tfvars` – basic CCN instance

```hcl
# Basic CCN instance configuration
ccn_instance = {
  name                   = "production-ccn"
  desc                   = "Production CCN interconnecting Beijing and Shanghai"
  qos                    = "AU"
  charge_type            = "POSTPAID"
  bandwidth_limit_type   = "INTER_REGION_LIMIT"
  enable_route_ecmp      = false
  enable_route_overlap   = true
  instance_metering_type = "BANDWIDTH"
  tags = {
    Environment = "production"
    NetworkType = "cross-region"
    ManagedBy   = "terraform"
  }
}
```

### Route tables and policies

```hcl
# CCN route tables
ccn_route_tables = {
  rt_default = {
    name = "default-rt"
    desc = "Default route table"
  }
  rt_isolated = {
    name = "isolated-rt"
    desc = "Isolated route table for restricted VPCs"
  }
}

# Input policy: only accept routes from Beijing VPCs into rt_isolated
ccnrt_input_policies = {
  isolate_bj = {
    route_table_name = "isolated-rt"
    policies = [
      {
        action = "accept"
        desc   = "ACCEPT BJ VPC ROUTES"
        route_conditions = [
          {
            name          = "instance-region"
            values        = ["ap-beijing"]
            match_pattern = 1
          }
        ]
      },
      {
        action = "drop"
        desc   = "DROP ALL OTHER ROUTES"
        route_conditions = [
          {
            name          = "instance-type"
            values        = ["VPC"]
            match_pattern = 1
          }
        ]
      }
    ]
  }
}

# Broadcast policy: advertise only CIDR 10.0.0.0/8 to Shanghai
ccnrt_broadcast_policies = {
  adv_bj = {
    route_table_name = "isolated-rt"
    policies = [
      {
        action = "accept"
        desc   = "ADVERTISE INTERNAL CIDR"
        route_conditions = [
          {
            name          = "cidr-block"
            values        = ["10.0.0.0/8"]
            match_pattern = 1
          }
        ]
        broadcast_conditions = [
          {
            name          = "instance-region"
            values        = ["ap-shanghai"]
            match_pattern = 1
          }
        ]
      }
    ]
  }
}
```

### Attachments (same-account and cross-account)

```hcl
# Initiate attachments from this account
ccn_attachments = [
  {
    ccn_id           = "ccn-xxxxxxxx"
    ccn_uin          = "100000000001"
    instance_id      = "vpc-axrsmmrv"
    instance_region  = "ap-beijing"
    instance_type    = "VPC"
    description      = "Attach Beijing VPC"
    route_table_name = "default-rt"
  },
  {
    ccn_id          = "ccn-xxxxxxxx"
    ccn_uin         = "100000000001"
    instance_id     = "vpngw-33p5vnwd"
    instance_region = "ap-shanghai"
    instance_type   = "VPNGW"
    description     = "Attach Shanghai VPN gateway"
  }
]

# CCN owner accepts a cross-account attachment request
ccn_accept_attachments = [
  {
    ccn_id          = "ccn-xxxxxxxx"
    instance_id     = "vpc-other-account"
    instance_type   = "VPC"
    instance_region = "ap-guangzhou"
    description     = "Accept partner Guangzhou VPC"
  }
]

# CCN owner rejects an attachment request
ccn_reject_attachments = [
  {
    ccn_id          = "ccn-xxxxxxxx"
    instance_id     = "dcg-untrusted"
    instance_type   = "DIRECTCONNECT"
    instance_region = "ap-shanghai"
    description     = "Reject untrusted Direct Connect"
  }
]

# Reset an attachment state back to pending
ccn_reset_attachments = [
  {
    ccn_id          = "ccn-xxxxxxxx"
    ccn_uin         = "100000000001"
    instance_id     = "vpc-axrsmmrv"
    instance_type   = "VPC"
    instance_region = "ap-beijing"
    description     = "Reset Beijing VPC attachment"
  }
]
```

---

## Configuration Notes

### Bandwidth limit type

| Limit type | Description | Use case |
|------------|-------------|----------|
| **INTER_REGION_LIMIT** | Bandwidth limit between two specific regions. | Control bandwidth between a source and a destination region. |
| **OUTER_REGION_LIMIT** | Bandwidth limit from a region to all other regions. | Control egress bandwidth from one region to everywhere else. |

### Billing mode

| Billing mode | Description | Use case |
|--------------|-------------|----------|
| **PREPAID** | Pay in advance. | Long-term stable usage with predictable cost. |
| **POSTPAID** | Pay by actual usage. | Elastic usage. |
| **BANDWIDTH** (`instance_metering_type`) | Billed by bandwidth. | Bandwidth-guaranteed scenarios. |
| **TRAFFIC** (`instance_metering_type`) | Billed by traffic. | Traffic-burst scenarios. |

### Service quality (QoS)

| QoS | Description | Network performance |
|-----|-------------|---------------------|
| **PT** | Platinum | Highest performance, lowest latency, highest cost. |
| **AU** | Gold | High performance, balanced cost (default). |
| **AG** | Silver | Standard performance, cost-optimized. |

### Route policy conditions

A policy matches routes/broadcasts by one or more conditions. Each condition uses:

- `name`: one of `instance-type`, `instance-region`, `instance-id`, `cidr-block`.
- `values`: set of values, e.g. `instance-type`: `VPC`,`VPNGW`,`DIRECTCONNECT`; `instance-region`: `ap-guangzhou`; `instance-id`: `vpc-axrsmmrv`; `cidr-block`: `172.0.0.0/8`.
- `match_pattern`: `1` (precise matching) or `0` (fuzzy matching).

Input policies decide which received routes are accepted/dropped; broadcast policies decide which routes are advertised to which destinations.

### Attachment & cross-account management

- `ccn_attachments` initiates attachments from the current account (requires `ccn_uin`).
- `ccn_accept_attachments` / `ccn_reject_attachments` are used by the CCN owner to accept/reject attachment requests from other accounts.
- `ccn_reset_attachments` resets an attachment state back to pending (requires `ccn_uin`).
- `instance_type` must be one of: `VPC`, `VPNGW`, `DIRECTCONNECT`, `BMVPC`, `EDGE`.

---

## Important Notes

> ⚠️ **Important: read carefully before making changes**

1. **Permissions**
   - Ensure the executing account has CCN management permissions (`QcloudCCNFullAccess`).
   - VPC attachments also require `QcloudVPCFullAccess`.

2. **Name/description length**
   - CCN name ≤ 60 bytes; CCN description ≤ 100 bytes.
   - Avoid overly long names/descriptions.

3. **Region codes**
   - Use standard region codes such as `ap-beijing`, `ap-shanghai`, `ap-guangzhou`.
   - Verify the region is available in Tencent Cloud.

4. **Billing mode**
   - `PREPAID` requires upfront payment; `POSTPAID` bills by usage.
   - `instance_metering_type` further controls bandwidth vs. traffic billing.

5. **QoS selection**
   - Platinum (`PT`) gives best performance at highest cost.
   - Gold (`AU`) balances performance and cost (default).
   - Silver (`AG`) is the most cost-efficient but lower performance.

6. **Route overlap constraint**
   - `enable_route_overlap` defaults to `true` and **cannot be set to `false`**.

7. **Bandwidth limit type and regions**
   - `OUTER_REGION_LIMIT` does not require a destination region.
   - `INTER_REGION_LIMIT` requires both source and destination regions configured.

8. **Cross-account attachments**
   - Accept/reject/reset operations require the CCN owner account context.
   - Provide the correct `ccn_uin` for attach/reset operations.
   - `instance_type` must be a valid enum value or validation fails.

9. **Tag management**
   - Add environment, business-unit tags for classification and cost allocation.
   - Use a consistent tagging convention.

---

## Troubleshooting

### Common errors and solutions

#### Error 1: Insufficient permissions

```
Error: [TencentCloudSDKError] Code=UnauthorizedOperation
Message=You are not authorized to perform the operation
```

**Cause**: The executing account lacks CCN management permissions.
**Solution**:
- Confirm the provider credentials have the required permissions.
- Check `QcloudCCNFullAccess` is included.

#### Error 2: Name/description length exceeded

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Name length exceeds limit
```

**Cause**: The CCN name or description exceeds the length limit.
**Solution**:
- CCN name ≤ 60 bytes; description ≤ 100 bytes.
- Simplify the name/description content.

#### Error 3: Invalid region code

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid region code
```

**Cause**: The region code format is incorrect.
**Solution**:
- Use standard region codes (e.g. `ap-beijing`, `ap-shanghai`).
- Check spelling and region availability.

#### Error 4: Bandwidth limit configuration conflict

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Bandwidth limit configuration conflict
```

**Cause**: Bandwidth limit configuration is inconsistent.
**Solution**:
- `OUTER_REGION_LIMIT` does not require a destination region.
- `INTER_REGION_LIMIT` requires both source and destination regions.
- Ensure the limit type matches the region configuration.

#### Error 5: Unsupported billing type

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Unsupported charge type
```

**Cause**: The billing type is misconfigured.
**Solution**:
- Only `PREPAID` and `POSTPAID` are valid for `charge_type`.
- Only `BANDWIDTH` and `TRAFFIC` are valid for `instance_metering_type`.

#### Error 6: Invalid QoS level

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid QoS level
```

**Cause**: The QoS level is misconfigured.
**Solution**:
- Only `PT`, `AU`, `AG` are valid for `qos`.

#### Error 7: Invalid instance type in attachment

```
Error: [TencentCloudSDKError] Code=InvalidParameter
Message=Invalid instance type
```

**Cause**: `instance_type` is not a valid enum value.
**Solution**:
- Use one of: `VPC`, `VPNGW`, `DIRECTCONNECT`, `BMVPC`, `EDGE`.

## License

See [LICENSE](../../../LICENSE) for full details.