# SSM Secret Management Example - Database Password Configuration

# Call tencentcloud-ssm module to create database password secret
module "database_password_secret" {
  source = "../"
  
  # Required parameters
  secret_name        = "prod-database-password"
  secret_description = "生产环境数据库管理员密码"
  
  # Optional parameters
  secret_enabled             = true
  recovery_window_in_days    = 7
  secret_string              = "MySecureDatabasePassword123!"
  secret_version_id          = "v1"
  
  # Tags
  tags = {
    Environment = "production"
    Application = "web-app"
    Owner       = "devops-team"
  }
}

