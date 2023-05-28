variable "security_group_ids" {
  description = "Security group id to associate to ec2 instance"
  type        = list(string)
  default     = []
}
variable "subnet_id" {
  description = "Instance subnet id"
  type        = string
  default     = null
}
variable "availability_zone" {
  description = "Availability zone of the instance"
  type        = string
  default     = null
}
variable "ami" {
  description = "AMI id to use for instance"
  type        = string
  default     = null
}
variable "instance_type" {
  description = "Instance type for the instance"
  type        = string
  default     = null
}
variable "launch_template" {
  description = "Launch template for the instance"
  type = object({
    id      = string
    name    = string
    version = string
  })
  default = null
}
variable "key_name" {
  description = "Keypair name to use for instance ssh connection"
  type        = string
  default     = null
}
variable "tags" {
  description = "Tags to assign to instance"
  type        = map(any)
  default     = {}
}
variable "associate_public_ip_address" {
  description = "Associate a public ip to the instance to allow external connection"
  type        = bool
  default     = false
}
variable "spot_instance" {
  description = "Spot instance configuration"
  type        = object({
    block_duration_minutes = string
    wait_for_fulfillment = string
    spot_type = string
    spot_price = string
  })
  default     = null
}
