variable "vpc_name" {
  description = "VPC Name"
  type        = string
}
variable "vpc_tags" {
  description = "VPC tags"
  type        = map(any)
  default = {

  }
}
variable "environment" {
  description = "Deploy environment"
  type        = string
  default     = "prod"
}
variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}
variable "eks_tags" {
  description = "EKS Tags"
  type        = map(any)
  default = {

  }
}
variable "rds_database_name" {
  description = "RDS Database Name"
  type        = string
}
variable "rds_tags" {
  description = "RDS Instance tags"
  type        = map(any)
  default     = {}
}
variable "rds_identifier" {
  description = "RDS instance identifier"
  type        = string
}
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}
variable "delete_bastion_private_key_on_destroy" {
  description = "Delete bastion private key on destroy"
  type        = bool
  default     = null
}

variable "create_rds" {
  description = "Create RDS instance"
  type        = bool
  default     = false
}
variable "create_eks" {
  description = "Create EKS cluster"
  type        = bool
  default     = true
}
variable "jenkins_admin_user" {
  description = "Jenkins admin user"
  type        = string
  sensitive   = true
}
variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}
variable "eks_main_node_group_instance_type" {
  description = "EKS main node group instance type"
  type        = string
}
variable "eks_masters_auth_users" {
  description = "AWS users with access to EKS cluster"
  type = list(object({
    arn      = string
    username = string
  }))
  default = []
}
