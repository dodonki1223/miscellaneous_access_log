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
    NAT Gateway
      ネットワークアドレス変換サービス。NAT Gatewayを使用すると、プライベートサブネット内の
      インスタンスはVPC外のサービスに接続できるが外部サービスはそれらのインスタンスとの接続を開始できない
      NAT GatewayにEIPをバインドする（NAT Gatewayによるアクセス元IPアドレスの固定するため）
        詳しくはこちら：https://dev.classmethod.jp/articles/fix-sender-ip-address-with-nat-gateway/
      NAT Gateway は基本的にはパブリックサブネットに作成する
        プライベートサブネット→パブリックサブネット→NAT Gateway の順番
 */
resource "aws_eip" "miscellaneous_access_eip" {
  count      = length(var.public_subnet_cidrs)
  depends_on = [aws_internet_gateway.miscellaneous_access_igw]

  tags = merge(
    local.common-tags,
    tomap({
      "Name"        = "${var.application}-eip - ${count.index + 1}",
      "Description" = "Elastic IP"
    })
  )
}

resource "aws_nat_gateway" "miscellaneous_access_natgw" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.miscellaneous_access_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  depends_on    = [aws_internet_gateway.miscellaneous_access_igw]

  tags = merge(
    local.common-tags,
    tomap({
      "Name"        = "${var.application}-natgw - ${count.index + 1}",
      "Description" = "NAT Gateway"
    })
  )
}

/*
    ルートテーブル
      パブリックサブネット用のルートテーブルを作成する
        IGWとサブネットを紐付けることで外部からのアクセスを可能とするパブリックサブネットを作成する
      プライベートサブネット用のルートテーブルを作成する
        NAT Gateway を紐付けることでプライベートサブネットから外へ接続できるようにする（外部からはプライベートサブネットへアクセスできない）
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

resource "aws_route_table" "miscellaneous_access_private_rt" {
  vpc_id = aws_vpc.miscellaneous_access_vpc.id
  count  = length(var.private_subnet_cidrs)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.miscellaneous_access_natgw[count.index].id
  }
  tags = merge(
    local.common-tags,
    tomap({
      "Name"        = "${var.application}-private-route-table - ${count.index + 1}",
      "Description" = "private-route-table"
    })
  )
}

/*
    ルートテーブルとサブネットの紐付け
      パブリックサブネットとパブリックサブネット用のルートテーブルを紐付ける
      プライベートサブネットとプライベートサブネット用のルートテーブルを紐付ける
 */
resource "aws_route_table_association" "miscellaneous_access_public_rt_subnet" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.miscellaneous_access_public_rt[count.index].id
}

resource "aws_route_table_association" "miscellaneous_access_private_rt_subnet" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.miscellaneous_access_private_rt[count.index].id
}
