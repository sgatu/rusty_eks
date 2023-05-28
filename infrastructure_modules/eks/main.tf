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
    }
  }
  vpc_id                           = var.vpc_id
  subnet_ids                       = var.subnet_ids
  control_plane_subnet_ids         = var.subnet_ids
  self_managed_node_groups         = var.node_groups
  self_managed_node_group_defaults = var.node_group_defaults
  create_aws_auth_configmap        = true
  tags                             = var.tags
  count                            = var.create ? 1 : 0
}


resource "aws_eks_addon" "coredns" {
  cluster_name      = module.eks[0].cluster_name
  addon_name        = "coredns"
  addon_version     = var.core_dns_version
  resolve_conflicts = "OVERWRITE"
  preserve          = true
  tags              = merge(var.tags, { eks_addon = "coredns" })
  depends_on        = [module.eks]
  count             = var.create && var.addon_coredns ? 1 : 0
}
/*resource "aws_iam_policy" "worker_policy" {
  name        = "worker-policy-${var.cluster_name}"
  description = "Worker policy for the ALB Ingress"

  policy = data.local_file.iampolicy.content
  count  = var.create && var.aws_alb_controller ? 1 : 0
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = var.create && var.aws_alb_controller ? module.eks[0].self_managed_node_groups : {}

  policy_arn = aws_iam_policy.worker_policy[0].arn
  role       = each.value.iam_role_name
}*/

module "load_balancer_controller" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-lb-controller.git"

  cluster_identity_oidc_issuer     = module.eks[0].cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks[0].oidc_provider_arn
  cluster_name                     = module.eks[0].cluster_name
  depends_on                       = [module.eks]

  count = var.create && var.aws_alb_controller ? 1 : 0
}
/*
resource "helm_release" "ingress" {
  name       = "ingress"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.4.6"

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }
  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  count = var.create && var.aws_alb_controller ? 1 : 0
}
*/
