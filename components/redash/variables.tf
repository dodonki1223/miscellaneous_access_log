# Standard Variables
variable "aws_region" {
  description = "Target AWS Region"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "Local AWS Profile Name"
  type        = string
  default     = "terraform"
}

variable "application" {
  description = "Application Name"
  type        = string
  default     = "miscellaneous_access_log"
}

variable "component" {
  description = "Redash resource"
  type        = string
  default     = "redash"
}

# RDS Variables
variable "rds_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "9.6"
}

variable "rds_port_number" {
  description = "PostgreSQL port number"
  type        = number
  default     = 5436
}
