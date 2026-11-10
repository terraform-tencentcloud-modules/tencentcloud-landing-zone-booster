# SSM 示例变量定义

variable "environment" {
  description = "环境名称 (dev/staging/prod)"
  type        = string
  default     = "prod"
}

variable "application_name" {
  description = "应用名称"
  type        = string
  default     = "web-app"
}

variable "database_password" {
  description = "数据库密码（实际使用时应该从安全的地方获取）"
  type        = string
  sensitive   = true
  default     = "MySecureDatabasePassword123!"
}