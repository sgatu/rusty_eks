module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  cidr                 = var.vpc_cidr
  name                 = var.vpc_name
  azs                  = var.azs
  tags                 = var.tags
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  database_subnets     = var.database_subnets
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  public_subnet_tags   = local.public_subnet_tags
  private_subnet_tags  = local.private_subnet_tags
  database_subnet_tags = local.database_subnet_tags
  enable_nat_gateway   = true
  single_nat_gateway   = false
}

module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.17.2"

  count             = try(var.has_bastion) ? 1 : 0
  vpc_id            = module.vpc.vpc_id
  egress_rules      = ["all-all"]
  tags              = merge(var.tags, { Name = "bastion-sg" })
  ingress_with_self = [{ rule = "all-all" }]
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  name = "bastion-sg"
}
module "public_sg" {
  source       = "terraform-aws-modules/security-group/aws"
  version      = "~> 4.17.2"
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  name              = "public-sg"
  ingress_with_self = [{ rule = "all-all" }]
  vpc_id            = module.vpc.vpc_id
  tags              = merge(var.tags, { Name = "${var.security_group_prefix}-public-sg" })
}
module "private_sg" {
  source            = "terraform-aws-modules/security-group/aws"
  version           = "~> 4.17.2"
  vpc_id            = module.vpc.vpc_id
  egress_rules      = ["all-all"]
  ingress_with_self = [{ rule = "all-all" }]
  tags              = merge(var.tags, { Name = "${var.security_group_prefix}-private-sg" })
  name              = "private-sg"
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.public_sg.security_group_id
    },
    try(var.has_bastion) ? {
      rule                     = "ssh-tcp"
      source_security_group_id = module.bastion_sg[0].security_group_id
    } : {}
  ]
  number_of_computed_ingress_with_source_security_group_id = try(var.has_bastion) ? 2 : 1
}
module "database_sg" {
  source            = "terraform-aws-modules/security-group/aws"
  version           = "~> 4.17.2"
  vpc_id            = module.vpc.vpc_id
  egress_rules      = ["all-all"]
  tags              = merge(var.tags, { Name = "database-sg" })
  ingress_with_self = [{ rule = "all-all" }]
  name              = "database-sg"
  ingress_with_cidr_blocks = [
    {
      rule        = "mysql-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp",
      source_security_group_id = module.private_sg.security_group_id
    },
    {
      rule                     = "redis-tcp",
      source_security_group_id = module.private_sg.security_group_id
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 2

}

