module "vpc" {
  source             = "../../../infrastructure_modules/vpc"
  enable_nat_gateway = true
  private_subnets    = local.private_subnets
  public_subnets     = local.public_subnets
  database_subnets   = local.database_subnets
  azs                = local.azs
  vpc_cidr           = local.cidr
  vpc_name           = var.vpc_name

  tags = merge({ source = "Terraform" }, var.vpc_tags)
  private_subnet_tags = {
    format("kubernetes.io/cluster/%s", var.eks_cluster_name) = "shared"
    "kubernetes.io/role/internal-elb"                        = "1"
  }
  public_subnet_tags = {
    format("kubernetes.io/cluster/%s", var.eks_cluster_name) = "shared"
    "kubernetes.io/role/elb"                                 = "1"
  }
  security_group_prefix = var.eks_cluster_name
  has_bastion           = true
}

module "domains" {
  source = "../../../infrastructure_modules/domains"
  domains = {
    "sg-bacon.online" = "Z07853331JG2XXCIJ5YPC"
  }
}

module "bastion" {
  source            = "../../../infrastructure_modules/bastion"
  security_group_id = module.vpc.bastion_sg_id
  subnet_id         = module.vpc.public_subnet_ids[0]
  availability_zone = module.vpc.azs[0]
  is_spot           = false
  tags = {
    source = "Terraform"
    Name   = "Bastion"
  }
  output_private_key_path       = "./bastion_key.pem"
  delete_private_key_on_destroy = local.delete_bastion_private_key_on_destroy
}


module "rds" {
  source             = "../../../infrastructure_modules/storage/rds"
  username           = local.mysql_config.username
  password           = local.mysql_config.password
  identifier         = var.rds_identifier
  security_group     = module.vpc.database_sg_id
  vpc_id             = module.vpc.vpc_id
  db_name            = var.rds_database_name
  subnet_ids         = module.vpc.database_subnet_ids
  subnet_group_name  = format("%s-database-sgroup", var.eks_cluster_name)
  availability_zones = module.vpc.azs
  tags               = merge({ source = "Terraform" }, var.rds_tags)
  instance_class     = var.rds_instance_class
  mysql_version      = "5.7"
  count              = var.create_rds ? 1 : 0
}

module "eks" {
  source       = "../../../infrastructure_modules/eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  cluster_name = var.eks_cluster_name
  node_group_defaults = {
    # enable discovery of autoscaling groups by cluster-autoscaler
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled"                 = true
      "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned"
    }
  }
  node_groups = {
    main = {
      use_custom_launch_template = false
      name                       = "app"
      max_size                   = 5
      desired_size               = 2
      capacity_type              = "SPOT"
      platform                   = "linux"
      instance_type              = var.eks_main_node_group_instance_type
      key_name                   = "main-kp"
      vpc_security_group_ids     = [module.vpc.private_sg_id]
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }
  tags               = merge({ source = "Terraform" }, var.eks_tags)
  aws_alb_controller = true
  masters_auth_users = var.eks_masters_auth_users
  ecr_repositories = [
    {
      name       = "hello_rust"
      scan       = false
      max_images = 12
    }
  ]
  create = var.create_eks

}
module "devops" {
  source         = "../../../infrastructure_modules/devops"
  admin_password = var.jenkins_admin_password
  admin_user     = var.jenkins_admin_user
  env            = var.environment
  deploy_key_path = {
    private = local.devops.deploy_key_path
    public  = local.devops.deploy_key_pub_path
  }
  seed_key_path          = local.devops.seed_key_path
  domain                 = "devops.sg-bacon.online"
  domain_certificate_arn = lookup(module.domains.certificate_arns, "sg-bacon.online", "")
  aws_region             = local.region
  aws_user_id            = local.aws_user_id
  depends_on             = [module.eks, module.domains]
}
