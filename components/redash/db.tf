/*
    DBパラメータグループ
      postgresql.confファイルで設定する値はDBパラメータグループで設定する
      タイムゾーンをJSTに変更する
        https://aws.amazon.com/jp/premiumsupport/knowledge-center/rds-change-time-zone/
      設定できるパラメータは以下のドキュメントを確認すること
        https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.Parameters
 */
resource "aws_db_parameter_group" "miscellaneous_access_rds_pg" {
  name        = replace("${var.application}-rds-pg", "_", "-")
  family      = "postgres${var.rds_version}"
  description = "${var.application} db parameter group"

  parameter {
    name  = "timezone"
    value = "UTC+9"
  }
}

/*
    DBサブネットグループ
      DBを稼働させるサブネットをDBサブネットグループで定義する
      サブネットには異なるアベイラビリティゾーンのものを含む
 */
resource "aws_db_subnet_group" "miscellaneous_access_rds_sbg" {
  name       = replace("${var.application}-rds-sbg", "_", "-")
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
}

/*
    セキュリティグループ
      PostgreSQL のポート番号をVPC内で許可する
 */
module "postgres_sg" {
  source      = "../../modules/security_group"
  name        = "${var.application}-postgres-sg"
  description = "Allow port number for PostgreSQL"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  port        = var.rds_port_number
  cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
}
