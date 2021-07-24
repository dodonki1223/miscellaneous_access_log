data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_ssm_parameter" "github_token" {
  name = "/continuous_apply/github_token"
}
