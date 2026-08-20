# Input variable definitions
variable "ssh_key" {
  description = "SSH key pair configuration object"
  type = object({
    key_name            = string                    # The key pair's name (required)
    project_id          = optional(number, 0)       # ID of the project to which the created SSH key belongs
    public_key          = optional(string)          # Importing an existing public key and using TencentCloud key pair
    tags                = optional(map(string), {}) # Tags to associate with the SSH key pair
    enable_store_in_ssm = optional(bool, false)     # Enable store key in SSM, default value is false
  })
}
