module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v3.2.0"

  name               = "aws_esk_practice"
  cidr               = var.cidr
  azs                = var.azs
  public_subnets     = var.public_subnets
  enable_vpn_gateway = false
}