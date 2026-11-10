# SSH Key Terraform Module

This module provisions a **Tencent Cloud SSH key pair** (`tencentcloud_key_pair`) and optionally stores the key pair (including the private key) in Tencent Cloud SSM (`tencentcloud_ssm_secret`).

Key capabilities:

- **Key pair** — import an existing public key as a Tencent Cloud key pair (`tencentcloud_key_pair`). Both the generated public and private keys are returned.
- **SSM secret** — optionally stores the key pair (`key_name`, `public_key`, `private_key`) in SSM, controlled by `ssh_key.enable_store_in_ssm`. The secret name is derived from `key_name` with underscores replaced by hyphens, suffixed with `-secret`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| tencentcloud | >= 1.81.136 |

## Providers

| Provider | Source |
|----------|--------|
| tencentcloud | tencentcloudstack/tencentcloud |

## Resources

| Name | Type |
|------|------|
| `tencentcloud_key_pair.ssh_key_pair` | resource |
| `tencentcloud_ssm_secret.secret` | resource (count = 1 when `ssh_key.enable_store_in_ssm`) |
| `tencentcloud_ssm_secret_version.v1` | resource (secret version `v1`) |

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | `object` | yes | – | SSH key pair configuration. See structure below. |

### `ssh_key` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `key_name` | `string` | yes | – | The key pair name. |
| `project_id` | `number` | no | `0` | ID of the project to which the created SSH key belongs. |
| `public_key` | `string` | no | – | Importing an existing public key to use as a Tencent Cloud key pair. |
| `tags` | `map(string)` | no | `{}` | Tags to associate with the SSH key pair. |
| `enable_store_in_ssm` | `bool` | no | `false` | Enable storing the key pair in SSM. |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | ID of the SSH key pair. |
| <a name="output_public_key"></a> [public\_key](#output\_public\_key) | Public key (sensitive). |
| <a name="output_private_key"></a> [private\_key](#output\_private\_key) | Private key (sensitive). |
| <a name="output_create_time"></a> [create\_time](#output\_create\_time) | Creation time of the key pair. |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | ID of the SSM secret storing the SSH key pair (null when SSM storage is disabled). |

## Usage

### Basic key pair from an existing public key

```hcl
module "ssh_key" {
  source = "./modules/ssh-key"

  ssh_key = {
    key_name   = "my-ssh-key"
    project_id = 0
    public_key = "ssh-rsa AAAA..."
    tags = {
      env = "prod"
    }
  }
}
```

### Store the key pair in SSM

```hcl
module "ssh_key" {
  source = "./modules/ssh-key"

  ssh_key = {
    key_name            = "my_ssh_key"
    public_key          = "ssh-rsa AAAA..."
    enable_store_in_ssm = true
    tags = {
      env = "prod"
    }
  }
}
```

> **Notes**:
> - When `enable_store_in_ssm = true`, the secret name becomes `my-ssh-key-secret` (underscores in `key_name` are replaced with hyphens).
> - `public_key` and `private_key` outputs are marked sensitive.
