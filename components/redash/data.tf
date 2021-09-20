/*
    既にデプロイ済みのリソースの値を取得するための設定
      Redash Componentを作成する前には既にNetwork Component を作成していることが大前提となる
 */
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    region  = "ap-northeast-1"
    bucket  = "miscellaneous-access-log"
    key     = "network/terraform.tfstate"
    profile = "terraform"
  }
}
