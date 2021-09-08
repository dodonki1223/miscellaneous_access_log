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
  description = "Component Name"
  type        = string
  default     = "cicd"
}

# VPC Variables
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "192.168.0.0/16"
}
