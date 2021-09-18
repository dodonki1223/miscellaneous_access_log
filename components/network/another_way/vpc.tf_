/*
    VPC
      VPCを作成するとメインルートテーブルも作成されます
      メインルートテーブルはVPCに自動割り当てされるルートテーブルです
 */
resource "aws_vpc" "miscellaneous_access_vpc" {
  cidr_block = var.vpc_cidr
  /*
    common のタグ情報と個別のタグ情報を結合して設定する
      merge メソッドと tomap メソッドを使用して合算する
   */
  tags = merge(
    local.common-tags,
    tomap({
      "Name"        = "${var.application}-vpc",
      "Description" = "VPC for creating ${var.application} resources"
    })
  )
}
