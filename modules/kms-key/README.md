# tencentcloud-kms

Creates a Tencent Cloud KMS (Key Management Service) key with optional alias and key rotation.

## Features

- Create KMS keys for encryption
- Optional key alias support
- Key rotation configuration
- Enable/disable keys
- Tag support

## Requirements

| Name | Version |
|------|---------| 
| terraform | >= 0.12 |
| tencentcloud | >= 1.81.136 |

## Providers

| Name | Version |
|------|---------| 
| tencentcloud | >= 1.81.136 |

## Resources

| Name | Type |
|------|------|
| tencentcloud_kms_key | resource |
| tencentcloud_kms_key_alias | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_key | Whether to create the KMS key | bool | true | no |
| key_name | Name of the KMS key (alias) | string | "" | no |
| description | Description of the KMS key | string | "" | no |
| is_enabled | Whether the key is enabled | bool | true | no |
| tags | Tags to apply to the KMS key | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| key_id | The ID of the KMS key |
| key_state | The state of the KMS key |

## Usage Example

```hcl
module "kms" {
  source = "../../modules/tencentcloud-kms"

  create_key  = true
  key_name    = "my-kms-key"
  description = "KMS key for data encryption"
  is_enabled  = true
  
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Outputs Usage

```hcl
# Get the key ID
key_id = module.kms.key_id

# Get the key state
key_state = module.kms.key_state
```
