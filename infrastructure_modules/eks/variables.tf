variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}
variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.27"
}
variable "core_dns_version" {
  description = "EKS CoreDNS addon version"
  type        = string
  default     = "v1.10.1-eksbuild.1"
}
variable "allow_public_access" {
  description = "Allow Kubernetes to be accessed from outside the vpc"
  type        = bool
  default     = true
}
variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}
variable "subnet_ids" {
  description = "Subnet ids where EKS will run"
  type        = list(string)
}
variable "node_groups" {
  description = "Node group definition"
  type        = map(any)
}
variable "manage_aws_auth_configmap" {
  description = "manage_aws_auth_configmap"
  type        = bool
  default     = true
}
variable "create_aws_auth_configmap" {
  description = "create_aws_auth_configmap"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to assign to EKS cluster"
  type        = map(any)
}

variable "node_group_defaults" {
  description = "Node group default configurations"
  type        = any
  default = {

  }
}

variable "aws_alb_controller" {
  description = "Add alb controller to eks"
  type        = bool
  default     = true
}
variable "external_dns" {
  description = "Add external_dns helm"
  type        = bool
  default     = true
}
variable "create" {
  description = "Create eks cluster"
  type        = bool
  default     = true
}

variable "extra_security_group" {
  description = "Extra security group to add to eks cluster"
  type        = string
  default     = null
}
variable "ecr_repositories" {
  description = "ECR repositories"
  type = list(object({
    name       = string
    scan       = bool
    max_images = number
  }))
  default = []
}

variable "masters_auth_users" {
  description = "AWS users with access to EKS cluster"
  type = list(object({
    arn      = string
    username = string
  }))
  default = []
}
