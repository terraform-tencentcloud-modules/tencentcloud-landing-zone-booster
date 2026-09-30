# TencentCloud SSM 模块

本模块用于在腾讯云上创建和管理SSM（Secrets Manager）密钥和密钥版本。

## 功能特性

- 创建和管理SSM密钥
- 支持密钥版本管理
- 支持密钥自动轮换配置
- 支持多种密钥类型（用户定义、Redis等）
- 支持KMS加密密钥配置
- 完整的输出信息

## 使用方法

### 基本使用

```hcl
module "ssm_secret" {
  source = "./modules/tencentcloud-ssm"
  
  secret_name        = "my-secret"
  secret_description = "My application secret"
  secret_string      = "my-secret-value"
}
```

### 完整配置示例

```hcl
module "ssm_secret" {
  source = "./modules/tencentcloud-ssm"
  
  secret_name              = "my-secret"
  secret_description       = "My application secret"
  secret_string            = "my-secret-value"
  secret_type              = 0
  recovery_window_in_days  = 7
  secret_enabled           = true
  
  # 标签
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## 输入变量

### 基础配置

- `secret_name` (必需) - 密钥名称
- `secret_description` (可选) - 密钥描述
- `secret_version_id` (可选) - 密钥版本ID
- `secret_string` (可选) - 密钥明文内容
- `secret_binary` (可选) - 密钥二进制内容（base64格式）

### 其他配置

- `recovery_window_in_days` (可选) - 恢复窗口天数
- `secret_enabled` (可选) - 是否启用密钥
- `kms_key_id` (可选) - KMS加密密钥ID
- `kms_key_id_from_module` (可选) - 从KMS模块获取的密钥ID。优先级高于kms_key_id变量
- `additional_config` (可选) - 附加配置（JSON格式）
- `secret_type` (可选) - 密钥类型（0=用户定义，4=Redis）
- `tags` (可选) - 资源标签

### KMS密钥ID优先级

kms_key_id参数按照以下优先级顺序获取：
1. `kms_key_id_from_module` - 从KMS模块输出获取的密钥ID
2. `kms_key_id` - 直接指定的密钥ID变量
3. `null` - 如果两者都为空，则使用null（使用SSM默认CMK）

## 输出变量

- `ssm_secret_id` - SSM密钥ID
- `ssm_secret_status` - SSM密钥状态
- `ssm_secret_version_id` - SSM密钥版本ID
- `secret_details` - 完整的密钥详情（敏感信息）

## 注意事项

- `secret_string`和`secret_binary`只能指定其中一个
- 密钥名称在同一个地域内必须唯一
- 恢复窗口设置为0表示立即删除，1-30表示保留天数
- 启用轮换时，轮换频率必须至少7天

## 依赖要求

- Terraform >= 1.0.0
- TencentCloud Provider >= 1.81.0