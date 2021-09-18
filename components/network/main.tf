/*
    Elastic IP
      Nat Gateway に設定するための Elastic IP を予め用意していおく（NAT Gatewayによるアクセス元IPアドレスの固定するため）
        https://dev.classmethod.jp/articles/fix-sender-ip-address-with-nat-gateway/
      NAT Gateway は基本的にはパブリックサブネットに作成する（VPC モジュールでもパブリックサブネットに作成されるようになっている）
        プライベートサブネット→パブリックサブネット→NAT Gateway の順番
 */
resource "aws_eip" "nat" {
  count = 2
  vpc   = true
  tags = {
    Name = "${format("%s-eip-%02d", var.application, count.index + 1)}"
  }
}

/*
    VPC
      Terraform 公式の VPC モジュールを使用して作成する
      AZごとNat Gatewayを作成する
        Terraform公式のドキュメントを参考にする
          https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#nat-gateway-scenarios
        なぜAZごとに作成するの？
          公式の資料にこんなことが書かれています
            > 高可用性。各アベイラビリティーゾーンの NAT ゲートウェイは冗長性を持たせて実装されます。
              アベイラビリティーゾーンごとに NAT ゲートウェイを作成し、ゾーンに依存しないアーキテクチャにします。
            https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-nat-comparison.html
      予め設定したEIPを使う場合は以下の設定が必要（この設定にしないと余分なEIPが作られてしまう）
        external_nat_ip_ids    = "${aws_eip.nat.*.id}"
        reuse_nat_ips          = true
 */
module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = "${var.application}-vpc"
  cidr                   = var.vpc_cidr
  azs                    = var.azs
  private_subnets        = var.private_subnet_cidrs
  public_subnets         = var.public_subnet_cidrs
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  external_nat_ip_ids    = aws_eip.nat.*.id
  reuse_nat_ips          = true
  version                = "3.7.0"
}
