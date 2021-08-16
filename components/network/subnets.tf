// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
data "aws_availability_zones" "available" {}

/*
    パブリックサブネット
      variable の public_subnet_cidrs の値を使用して複数のパブリックサブネットを作成する
 */
resource "aws_subnet" "public_subnet" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.miscellaneous_access_vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  // 東京リージョンの場合は３つまで指定できる、４つだとエラーで落ちる
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common-tags,
    tomap({
      "Name"        = "${var.application}-public-subnet - ${count.index + 1}",
      "Description" = "Public subnet - ${count.index + 1}"
    })
  )
}
