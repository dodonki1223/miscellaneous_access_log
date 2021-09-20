variable "name" {}        // セキュリティグループの名前
variable "description" {} // セキュリティグループの説明
variable "vpc_id" {}      // VPCのID
variable "port" {}        // 通信を許可するポート番号
variable "cidr_blocks" {  // 通信を許可するCIDRブロック
  type = list(string)
}
