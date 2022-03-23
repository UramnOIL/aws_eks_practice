output vpc_id {
    value = module.vpc.vpc_id
}

output subnet_ids_for_eks {
    value = module.vpc.public_subnets
}