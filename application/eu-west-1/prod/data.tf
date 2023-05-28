data "aws_ssm_parameter" "database_config" {
  name            = "prod-database-config"
  with_decryption = true
}
/*data "aws_eks_cluster" "cluster" {
  count      = var.create_eks ? 1 : 0
  name       = module.eks.cluster_name
}
data "aws_eks_cluster_auth" "cluster_auth" {
  count      = var.create_eks ? 1 : 0
  name       = module.eks.cluster_name
}*/

locals {
  region                                = "eu-west-1"
  azs                                   = ["eu-west-1a", "eu-west-1b"]
  cidr                                  = "10.0.0.0/16"
  private_subnets                       = ["10.0.0.0/20", "10.0.16.0/20"]
  public_subnets                        = ["10.0.32.0/20", "10.0.48.0/20"]
  database_subnets                      = ["10.0.64.0/20", "10.0.80.0/20"]
  mysql_config                          = jsondecode(data.aws_ssm_parameter.database_config.value)
  database_storage                      = 10
  delete_bastion_private_key_on_destroy = coalesce(var.delete_bastion_private_key_on_destroy, false)
}
