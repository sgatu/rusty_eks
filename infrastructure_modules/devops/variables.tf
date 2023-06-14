variable "admin_user" {
  type      = string
  sensitive = true
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "git_key_path" {
  type = object({
    private = string
    public  = string
  })
}
