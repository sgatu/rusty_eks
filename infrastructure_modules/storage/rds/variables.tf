
variable "identifier" {
  description = "RDS instance identifier"
  type        = string
}
variable "mysql_version" {
  description = "Mysql Version for RDS instance"
  type        = string
  default     = "8.0"
}

variable "db_name" {
  description = "Database name"
  type        = string
}
variable "username" {
  description = "Mysql username"
  type        = string
}
variable "password" {
  description = "Mysql password"
  type        = string
}
variable "security_group" {
  description = "Security group id for database"
  type        = string
}
variable "vpc_id" {
  description = "VPC id where to run RDS"
  type        = string
}
variable "charset" {
  description = "Database server and client charset"
  type        = string
  default     = "utf8mb4"
}
variable "tags" {
  description = "Tags associated with RDS instance"
  type        = map(any)
}
variable "instance_class" {
  description = "Instance class used for database"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet ids for the database"
  type        = list(any)
}

variable "subnet_group_name" {
  description = "Subnet group name"
  type        = string
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}
