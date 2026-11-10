# TencentCloud SSM 模块示例

本示例展示了如何使用 `tencentcloud-ssm` Terraform 模块来管理腾讯云 Secrets Manager (SSM) 密钥。

## 示例内容

本示例创建了一个生产环境数据库密码的 SSM 密钥，包含以下配置：

- **密钥名称**: `prod-database-password`
- **描述**: 生产环境数据库管理员密码
- **密钥值**: 示例密码字符串
- **版本管理**: 支持密钥版本控制
- **标签**: 包含环境、应用和所有者信息

## 文件结构

```
example/
├── main.tf          # 主配置文件
├── variables.tf     # 变量定义文件
└── README.md        # 使用说明文档
```

## 使用方法

### 1. 初始化 Terraform

```bash
terraform init
```

### 2. 查看执行计划

```bash
terraform plan
```

### 3. 部署资源

```bash
terraform apply
```

### 4. 查看输出信息

部署完成后，Terraform 会输出以下信息：

- `secret_arn`: SSM 密钥的 ARN
- `secret_name`: SSM 密钥名称
- `secret_version_id`: 密钥版本ID

## 自定义配置

您可以根据需要修改 `main.tf` 文件中的参数：

```hcl
module "database_password_secret" {
  source = "../"
  
  # 修改密钥名称和描述
  secret_name        = "your-secret-name"
  secret_description = "您的密钥描述"
  
  # 修改密钥值（实际使用时应该从安全的地方获取）
  secret_string = "your-secret-value"
  
  # 根据需要调整其他参数
  secret_enabled          = true
  recovery_window_in_days = 7
  
  # 自定义标签
  tags = {
    Environment = "your-environment"
    Application = "your-application"
    Owner       = "your-team"
  }
}
```

## 安全注意事项

1. **密码安全**: 实际使用时，密码应该从安全的地方获取（如环境变量、CI/CD 系统的安全变量等）
2. **权限控制**: 确保执行 Terraform 的用户有足够的权限创建和管理 SSM 密钥
3. **密钥轮换**: 定期轮换密钥版本以提高安全性
4. **访问控制**: 严格控制对 SSM 密钥的访问权限

## 清理资源

如需删除创建的 SSM 密钥：

```bash
terraform destroy
```

## 更多信息

- [腾讯云 SSM 文档](https://cloud.tencent.com/document/product/1140)
- [Terraform TencentCloud Provider](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest)