/*
    IGW（インターネットゲートウェイ）
      VPCとインターネットとの間の通信を可能にするVPCコンポーネント
 */
resource "aws_internet_gateway" "miscellaneous_access_igw" {
  vpc_id = aws_vpc.miscellaneous_access_vpc.id

  tags = merge(
    local.common-tags,
    tomap({
      "Name"        = "${var.application} IGW",
      "Description" = "Internet Gateway"
    })
  )
}

/*
    ルートテーブル
      パブリックサブネット用のルートテーブルを作成する
        IGWとサブネットを紐付けることで外部からのアクセスを可能とするパブリックサブネットを作成する
 */
resource "aws_route_table" "miscellaneous_access_public_rt" {
  vpc_id = aws_vpc.miscellaneous_access_vpc.id
  count  = length(var.public_subnet_cidrs)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.miscellaneous_access_igw.id
  }
  tags = merge(
    local.common-tags,
    tomap({
      "Name"        = "${var.application}-public-route-table - ${count.index + 1}",
      "Description" = "public-route-table"
    })
  )
}

/*
    ルートテーブルとサブネットの紐付け
      パブリックサブネットとパブリックサブネット用のルートテーブルを紐付ける
 */
resource "aws_route_table_association" "miscellaneous_access_public_rt_subnet" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.miscellaneous_access_public_rt[count.index].id
}
