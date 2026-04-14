# TencentCloud SSM Module Example

This example demonstrates how to use the `tencentcloud-ssm` Terraform module to manage Tencent Cloud Secrets Manager (SSM) secrets.

## Example Overview

This example creates a production environment database password SSM secret with the following configuration:

- **Secret Name**: `prod-database-password`
- **Description**: Production environment database administrator password
- **Secret Value**: Example password string
- **Version Management**: Supports secret version control
- **Tags**: Includes environment, application, and owner information

## File Structure

```
example/
├── main.tf          # Main configuration file
├── variables.tf     # Variable definitions
├── outputs.tf       # Output definitions
└── README_EN.md     # English documentation
```

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review Execution Plan

```bash
terraform plan
```

### 3. Deploy Resources

```bash
terraform apply
```

### 4. View Output Information

After deployment, Terraform will output the following information:

- `secret_arn`: ARN of the SSM secret
- `secret_name`: SSM secret name
- `secret_version_id`: Secret version ID

## Custom Configuration

You can modify the parameters in the `main.tf` file according to your needs:

```hcl
module "database_password_secret" {
  source = "../"
  
  # Modify secret name and description
  secret_name        = "your-secret-name"
  secret_description = "Your secret description"
  
  # Modify secret value (should be obtained from secure sources in production)
  secret_string = "your-secret-value"
  
  # Adjust other parameters as needed
  secret_enabled          = true
  recovery_window_in_days = 7
  
  # Custom tags
  tags = {
    Environment = "your-environment"
    Application = "your-application"
    Owner       = "your-team"
  }
}
```

## Security Considerations

1. **Password Security**: In production use, passwords should be obtained from secure sources (environment variables, CI/CD system secure variables, etc.)
2. **Permission Control**: Ensure the user executing Terraform has sufficient permissions to create and manage SSM secrets
3. **Secret Rotation**: Regularly rotate secret versions to enhance security
4. **Access Control**: Strictly control access permissions to SSM secrets

## Cleanup Resources

To delete the created SSM secret:

```bash
terraform destroy
```

## Additional Information

- [Tencent Cloud SSM Documentation](https://cloud.tencent.com/document/product/1140)
- [Terraform TencentCloud Provider](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest)