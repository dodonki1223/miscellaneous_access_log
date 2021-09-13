terraform {
  required_version = "1.0.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.51.0"
    }
  }
  /*
      tfstateファイルの保存場所をS3に設定する
      ここでは variables が使えないためおとなしくハードコーディングする
        詳しくはこちらを：https://qiita.com/ymmy02/items/e7368abd8e3dafbc5c52
   */
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    bucket  = "miscellaneous-access-log"
    key     = "network/terraform.tfstate"
    profile = "terraform"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
