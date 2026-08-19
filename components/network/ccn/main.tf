################################################################################
# CCN
################################################################################
resource "tencentcloud_ccn" "instance" {
  name                   = var.ccn_instance.name
  description            = var.ccn_instance.desc
  qos                    = var.ccn_instance.qos
  charge_type            = var.ccn_instance.charge_type
  bandwidth_limit_type   = var.ccn_instance.bandwidth_limit_type
  route_ecmp_flag        = var.ccn_instance.enable_route_ecmp
  route_overlap_flag     = var.ccn_instance.enable_route_overlap
  instance_metering_type = var.ccn_instance.instance_metering_type
  tags                   = var.ccn_instance.tags
}

# Create CCN route tables
resource "tencentcloud_ccn_route_table" "route_tables" {
  for_each = var.ccn_route_tables
  
  ccn_id      = tencentcloud_ccn.instance.id
  name        = each.value.name
  description = each.value.desc

  depends_on = [ tencentcloud_ccn.instance ]
}

# Configure CCN input policies
resource "tencentcloud_ccn_route_table_input_policies" "input_policies" {
  for_each = var.ccnrt_input_policies

  ccn_id         = tencentcloud_ccn.instance.id
  route_table_id = tencentcloud_ccn_route_table.route_tables[each.value.route_table_name].id
  
  dynamic "policies" {
    for_each = each.value.policies
    content {
      action      = policies.value.action
      description = policies.value.desc
      dynamic "route_conditions" {
        for_each = policies.value.route_conditions
        content {
          name          = route_conditions.value.name
          values        = route_conditions.value.values
          match_pattern = route_conditions.value.match_pattern
        }
      }
    }
  }

  depends_on = [ tencentcloud_ccn_route_table.route_tables ]
}

# Configure CCN broadcast policies
resource "tencentcloud_ccn_route_table_broadcast_policies" "broadcast_policies" {
  for_each = var.ccnrt_broadcast_policies

  ccn_id         = tencentcloud_ccn.instance.id
  route_table_id = tencentcloud_ccn_route_table.route_tables[each.value.route_table_name].id
  
  dynamic "policies" {
    for_each = each.value.policies
    content {
      action      = policies.value.action
      description = policies.value.desc
      dynamic "route_conditions" {
        for_each = policies.value.route_conditions
        content {
          name          = route_conditions.value.name
          values        = route_conditions.value.values
          match_pattern = route_conditions.value.match_pattern
        }
      }
      dynamic "broadcast_conditions" {
        for_each = policies.value.broadcast_conditions
        content {
          name          = broadcast_conditions.value.name
          values        = broadcast_conditions.value.values
          match_pattern = broadcast_conditions.value.match_pattern
        }
      }
    }
  }

  depends_on = [ tencentcloud_ccn_route_table.route_tables ]
}

# ============================================================================
# CCN Attachment Resources (Initiate Attachment)
# Supports:
# 1. Same-account CCN instance attachment
# 2. Cross-account CCN instance attachment with:
#    - Initiate attachment request
#    - Accept attachment request
#    - Reject attachment request
#    - Reset attachment state
# ============================================================================
resource "tencentcloud_ccn_attachment_v2" "attachments" {
  for_each = { for att in var.ccn_attachments : att.instance_id => att}

  ccn_id  = each.value.ccn_id != null &&  each.value.ccn_id != "" ? each.value.ccn_id : tencentcloud_ccn.instance.id
  ccn_uin = each.value.ccn_uin

  instance_id     = each.value.instance_id
  instance_region = each.value.instance_region
  instance_type   = each.value.instance_type
  description     = each.value.description
  route_table_id  = each.value.route_table_id != null ? each.value.route_table_id : try(tencentcloud_ccn_route_table.route_tables[each.value.route_table_name].id, null)

  # Validation: Ensure required parameters are provided
  lifecycle {
    precondition {
      condition     = each.value.instance_region != null && each.value.instance_region != ""
      error_message = "region must be provided when creating an attachment."
    }
  }

  depends_on = [
    tencentcloud_ccn.instance,
    tencentcloud_ccn_route_table.route_tables
  ]
}

# ============================================================================
# CCN Attachment Accept Resources (Cross-account Operations)
# ============================================================================
resource "tencentcloud_ccn_instances_accept_attach" "accept_attaches" {
  for_each = { for acc in var.ccn_accept_attachments : acc.instance_id => acc}

  ccn_id  = each.value.ccn_id != null &&  each.value.ccn_id != "" ? each.value.ccn_id : tencentcloud_ccn.instance.id
  
  instances {
    instance_region = each.value.instance_region
    instance_id     = each.value.instance_id
    instance_type   = each.value.instance_type
    description     = each.value.description
  }

  # Validation: Ensure required parameters are provided
  lifecycle {
    precondition {
      condition     = each.value.instance_region != null && each.value.instance_region != ""
      error_message = "region must be provided when accepting an attachment."
    }
  }

  depends_on = [ tencentcloud_ccn_attachment_v2.attachments ]
}

# Reject CCN attachment requests
# Used by CCN owner to reject attachment requests from other accounts
resource "tencentcloud_ccn_instances_reject_attach" "reject_attaches" {
  for_each = { for rej in var.ccn_reject_attachments : rej.instance_id => rej}

  ccn_id  = each.value.ccn_id != null &&  each.value.ccn_id != "" ? each.value.ccn_id : tencentcloud_ccn.instance.id
  
  instances {
    instance_region = each.value.instance_region
    instance_id     = each.value.instance_id
    instance_type   = each.value.instance_type
    description     = each.value.description
  }

  # Validation: Ensure required parameters are provided
  lifecycle {
    precondition {
      condition     = each.value.instance_region != null && each.value.instance_region != ""
      error_message = "region must be provided when rejecting an attachment."
    }
  }

  depends_on = [ tencentcloud_ccn_attachment_v2.attachments ]
}

# Reset CCN attachment state
# Used to reset attachment state back to pending
resource "tencentcloud_ccn_instances_reset_attach" "reset_attaches" {
  for_each = { for reset in var.ccn_reset_attachments : reset.instance_id => reset}

  ccn_id  = each.value.ccn_id != null &&  each.value.ccn_id != "" ? each.value.ccn_id : tencentcloud_ccn.instance.id
  ccn_uin = each.value.ccn_uin
  
  instances {
    instance_region = each.value.instance_region
    instance_id     = each.value.instance_id
    instance_type   = each.value.instance_type
    description     = each.value.description
  }

  # Validation: Ensure required parameters are provided
  lifecycle {
    precondition {
      condition     = each.value.instance_region != null && each.value.instance_region != ""
      error_message = "region must be provided when resetting an attachment."
    }
    
    precondition {
      condition     = each.value.ccn_uin != null && each.value.ccn_uin != "" && can(regex("^[0-9]+$", each.value.ccn_uin))
      error_message = "ccn_uin must be provided with a numeric string when resetting an attachment."
    }
  }

  depends_on = [ tencentcloud_ccn_attachment_v2.attachments ]
}