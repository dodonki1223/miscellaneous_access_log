terraform {
  required_version = "1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.51.0"
    }
  }
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    bucket  = "miscellaneous-access-log"
    key     = "cicd/terraform.tfstate"
    profile = "terraform"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
