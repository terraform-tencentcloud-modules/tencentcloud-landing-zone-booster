variable "member_identity_ids" {
  description = "A map of organization members. Key is unique member name."
  type = list(object({
    member_uin   = number       # Member UIN
    identity_ids = list(number) # Identity Id list. Up to 5.
  }))
}