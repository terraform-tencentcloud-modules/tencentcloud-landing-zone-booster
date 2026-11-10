locals {

  statement = [for s in var.allowed_services :
    {
      action = [
        "${s}:Describe*",
      ]
      resource = ["*"]
      effect : "allow"
    }
  ]
  allStatement = concat(local.statement, var.additional_policy)
  policy = {
    version : "2.0"
    statement : local.allStatement
  }

}

resource "tencentcloud_cam_policy" "this" {
  count       = var.create_policy ? 1 : 0
  name        = var.name
  description = var.description
  document    = jsonencode(local.policy)
}