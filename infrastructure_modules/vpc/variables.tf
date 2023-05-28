variable "vpc_cidr" {
  description = "CDIR for the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to add to VPC related resources"
  type        = map(any)
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "azs" {
  description = "Availability zones for te VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "VPC private subnets definition"
  type        = list(any)
}
variable "public_subnets" {
  description = "VPC public subnets"
  type        = list(any)
}
variable "database_subnets" {
  description = "VPC database subnets"
  type        = list(any)
}
variable "enable_dns_support" {
  description = "Enable dns support in VPC"
  type        = bool
  default     = true
}
variable "enable_dns_hostnames" {
  description = "Enable dns hostnames in VPC"
  type        = bool
  default     = true
}
variable "enable_nat_gateway" {
  description = "Enable nat gateway in VPC"
  type        = bool
}

variable "private_subnet_tags" {
  description = "Extra tags for private subnet"
  type        = map(any)
}
variable "public_subnet_tags" {
  description = "Extra tags for public subnet"
  type        = map(any)
}
variable "security_group_prefix" {
  description = "Security group name prefix"
  type        = string
  default     = ""
}

variable "has_bastion" {
  description = "Create the necessary configuration for a bastion instance"
  type        = bool
  default     = false
}
