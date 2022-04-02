module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v3.2.0"

  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  name               = "aws_esk_practice"
  cidr               = var.cidr
  azs                = var.azs
  public_subnets     = var.public_subnets
  enable_vpn_gateway = false
}