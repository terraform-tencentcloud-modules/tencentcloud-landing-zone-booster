# TencentCloud SSM Module

This module is used to create and manage SSM (Secrets Manager) secrets and secret versions on TencentCloud.

## Features

- Create and manage SSM secrets
- Support secret version management

- Support multiple secret types (user-defined, Redis, etc.)
- Support KMS encryption key configuration
- Complete output information

## Usage

### Basic Usage

```hcl
module "ssm_secret" {
  source = "./modules/tencentcloud-ssm"
  
  secret_name        = "my-secret"
  secret_description = "My application secret"
  secret_string      = "my-secret-value"
}
```

### Complete Configuration Example

```hcl
module "ssm_secret" {
  source = "./modules/tencentcloud-ssm"
  
  secret_name              = "my-secret"
  secret_description       = "My application secret"
  secret_string            = "my-secret-value"
  secret_type              = 0
  recovery_window_in_days  = 7
  secret_enabled           = true
  
  # Tags
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Input Variables

### Basic Configuration

- `secret_name` (Required) - Secret name
- `secret_description` (Optional) - Secret description
- `secret_version_id` (Optional) - Secret version ID
- `secret_string` (Optional) - Secret text in plain text
- `secret_binary` (Optional) - Secret binary data in base64 format

### Other Configuration

- `recovery_window_in_days` (Optional) - Recovery window in days
- `secret_enabled` (Optional) - Whether the secret is enabled
- `kms_key_id` (Optional) - KMS key ID used for encryption
- `kms_key_id_from_module` (Optional) - KMS key ID from KMS module output. Takes precedence over kms_key_id variable
- `additional_config` (Optional) - Additional configuration in JSON format
- `secret_type` (Optional) - Secret type (0=user-defined, 4=Redis)
- `tags` (Optional) - Resource tags

### KMS Key ID Priority

kms_key_id parameter follows this priority order:
1. `kms_key_id_from_module` - KMS key ID from KMS module output
2. `kms_key_id` - Directly specified KMS key ID variable
3. `null` - If both are empty, use null (use SSM default CMK)

## Output Variables

- `ssm_secret_id` - SSM secret ID
- `ssm_secret_status` - SSM secret status
- `ssm_secret_version_id` - SSM secret version ID
- `secret_details` - Complete secret details (sensitive)

## Notes

- Only one of `secret_string` or `secret_binary` can be specified
- Secret names must be unique within the same region
- Recovery window of 0 means delete immediately, 1-30 means retention days


## Requirements

- Terraform >= 1.0.0
- TencentCloud Provider >= 1.81.0