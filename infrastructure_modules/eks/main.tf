/*resource "aws_iam_policy" "csi_policy" {
  policy      = data.local_file.csi_policy.content
  name_prefix = "${var.cluster_name}-CSI"
}*/

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                          = var.cluster_name
  cluster_version                       = var.cluster_version
  cluster_endpoint_public_access        = var.allow_public_access
  cluster_additional_security_group_ids = var.extra_security_group == null ? [] : [var.extra_security_group]
  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    },
    coredns = {
      most_recent = true
    },
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
  vpc_id                           = var.vpc_id
  subnet_ids                       = var.subnet_ids
  control_plane_subnet_ids         = var.subnet_ids
  self_managed_node_groups         = var.node_groups
  self_managed_node_group_defaults = var.node_group_defaults
  create_aws_auth_configmap        = true
  tags                             = var.tags

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::853492837442:root"
      username = "sg.bacon"
      groups   = ["system:masters"]
    }
  ]
  iam_role_additional_policies = {
    AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }
  count = var.create ? 1 : 0
}


module "load_balancer_controller" {
  source = "./lb-controller"

  cluster_identity_oidc_issuer     = module.eks[0].cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks[0].oidc_provider_arn
  cluster_name                     = module.eks[0].cluster_name
  // namespace                        = "tools"

  create_namespace = true
  depends_on       = [module.eks]

  count = var.create && var.aws_alb_controller ? 1 : 0
}

/*resource "helm_release" "secrets-store-csi" {
  name       = "secrets-store-csi"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"
  version    = "1.3.0"
  values     = ["${file(format("%s/config/jenkins/values.yaml", path.module))}"]
}*/
module "ecr" {
  source          = "terraform-aws-modules/ecr/aws"
  repository_name = local.repository_name
  repository_type = "private"
  /*repository_read_access_arns       = ["arn:aws:iam::012345678901:role/terraform"]
  repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]*/

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 12
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter         = "*"
      filter_type    = "WILDCARD"
    }
  ]

  tags  = var.tags
  count = var.create ? 1 : 0
}
