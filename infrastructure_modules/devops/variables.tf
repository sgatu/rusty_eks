variable "admin_user" {
  type      = string
  sensitive = true
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "deploy_key_path" {
  type = object({
    private = string
    public  = string
  })
}
variable "seed_key_path" {
  type = string
}
