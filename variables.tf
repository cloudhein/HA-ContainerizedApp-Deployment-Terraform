variable "aws_region" {
  type        = string
  description = "The region of the AWS to provision the resources"
  default     = "ap-northeast-1"
}

variable "profile" {
  type        = string
  description = "The profile to use"
  default     = "terraform-dev-role"
}

variable "instance_config" {
  type = object({
    instance_name = string
    instance_type = string
    environment   = string
  })
  description = "Instance configuration"

  validation {
    condition     = length(var.instance_config.instance_name) > 5 && length(var.instance_config.instance_name) < 20
    error_message = "The character length of the instance name should be between 5 and 20"
  }

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t2.medium", "t3.medium"], var.instance_config.instance_type)
    error_message = "The allowed instance types are t2.micro and t3.micro and t2.medium and t3.medium"
  }

  validation {
    condition     = contains(["dev", "staging", "prod"], var.instance_config.environment)
    error_message = "The allowed environments are dev and staging and prod"
  }
}

variable "create_instances" {
  type        = bool
  description = "Whether to create instances or not"
  default     = true
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  validation {
    condition     = var.instance_count > 0 && var.instance_count < 10
    error_message = "The instance count should be between 1 and 10"
  }
}

variable "rds_db_username" {
  type        = string
  description = "The username of the RDS database"
  sensitive   = true
  validation {
    condition     = length(var.rds_db_username) >= 4 && length(var.rds_db_username) <= 20
    error_message = "The character length of the username should be between 4 and 20"
  }
}

variable "rds_db_password" {
  type        = string
  description = "The password of the RDS database"
  sensitive   = true
  validation {
    condition     = length(var.rds_db_password) >= 8 && length(var.rds_db_password) <= 20
    error_message = "The character length of the password should be between 8 and 20"
  }
}

variable "rds_db_name" {
  type        = string
  description = "The name of the RDS database"
  validation {
    condition     = length(var.rds_db_name) >= 4 && length(var.rds_db_name) <= 20
    error_message = "The character length of the database name should be between 4 and 20"
  }
}