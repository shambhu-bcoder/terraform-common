variable "key_name" {
  description = "Enter or set a name of the key pair"
  type        = string
  default     = "mytuur-prod"
}

variable "mongodb_username" {
  description = "MongoDB admin username"
  type        = string
  default     = "mytuur"
}

variable "mongodb_password" {
  description = "MongoDB admin password"
  type        = string
  default     = "mytuurAdmin345"
}