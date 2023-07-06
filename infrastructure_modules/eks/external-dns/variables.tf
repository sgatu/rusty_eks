variable "cluster_name" {
  type = string
}
variable "enabled" {
  type    = bool
  default = true
}
variable "cluster_identity_oidc_issuer_arn" {
  type = string
}
variable "cluster_identity_oidc_issuer" {
  type = string
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "AWS Load Balancer Controller Helm chart namespace which the service will be created."
}

variable "service_account_name" {
  type        = string
  default     = "aws-externaldns-controller"
  description = "The kubernetes service account name."
}

variable "arn_format" {
  type        = string
  default     = "aws"
  description = "ARNs identifier, usefull for GovCloud begin with `aws-us-gov-<region>`."
}
variable "helm_chart_name" {
  type        = string
  default     = "external-dns"
  description = "AWS External DNS Chart name."
}

variable "helm_chart_release_name" {
  type        = string
  default     = "external-dns"
  description = "AWS External DNS Chart release name."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://kubernetes-sigs.github.io/external-dns"
  description = "AWS External DNS Helm repository name."
}

variable "helm_chart_version" {
  type        = string
  default     = "1.13.0"
  description = "AWS External DNS Chart version."
}
variable "settings" {
  type        = any
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/kubernetes-sigs/external-dns."
}

variable "roles" {
  type = list(object({
    name      = string
    namespace = string
    secrets   = list(string)
  }))
  default     = []
  description = "RBAC roles that give secret access in other namespaces to the lb controller"
}
