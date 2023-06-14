
locals {
  git_key_secret_name = "git-deploy-key"
  git_key_path = {
    private = coalesce(var.git_key_path.private, "./git_private.pem")
    public  = coalesce(var.git_key_path.public, "./git_public.pem")
  }
}
data "local_file" "git_ssh_key" {
  filename = local.git_key_path.private
}
