module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "aep-cluster"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    ami_type       = "BOTTLEROCKET_ARM_64"
    disk_size      = 50
    instance_types = ["t4g.small"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 4
      desired_size = 2

      vpc_security_group_ids = [aws_security_group.additional.id]
    }
  }
}

resource "aws_security_group" "additional" {
  name_prefix = "aep-additional"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}