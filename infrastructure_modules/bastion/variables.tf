

variable "subnet_id" {
  description = "Subnet id where the instance is going to be launched"
  type        = string
}

variable "security_group_id" {
  description = "Bastion security group"
  type        = string
}

variable "tags" {
  description = "Bastion instance tags"
  type        = map(any)
}
variable "availability_zone" {
  description = "Bastion instance az"
  type        = string
}

variable "output_private_key_path" {
  description = "Private key output path"
  type        = string
}
variable "delete_private_key_on_destroy" {
  description = "Delete private key on destroy"
  type        = bool
  default     = false
}
variable "is_spot" {
  description = "Mount bastion as spot instance"
  type        = bool
  default     = true
}
variable "spot_config" {
  description = "Spot instance request configuration"
  type = object({
    block_duration_minutes = string
    wait_for_fulfillment   = string
    spot_type              = string
    spot_price             = string
  })
  default = null
}
