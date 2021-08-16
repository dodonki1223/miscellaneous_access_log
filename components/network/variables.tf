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
  description = "Network resource"
  type        = string
  default     = "network"
}

# VPC Variables
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet - CIDR"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}
