variable "key_name" {
  description = "Enter or set a name of the key pair"
}

variable "mongodb_username" {
  description = "MongoDB admin username"
  type        = string
  default     = "muytuur"
}

variable "mongodb_password" {
  description = "MongoDB admin password"
  type        = string
  default     = "mytuurAdmin345"
}