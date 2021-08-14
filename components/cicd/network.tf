resource "aws_vpc" "continuous_apply" {
  cidr_block = var.vpc_cidr
  tags = merge(
    local.common-tags,
    tomap({
      "Name"        = "${var.application}-${var.component}-vpc",
      "Description" = "VPC for creating ${var.application} resources"
    })
  )
}
