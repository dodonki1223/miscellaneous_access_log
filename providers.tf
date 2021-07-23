terraform {
  required_version = "1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.51.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "terraform"
}
