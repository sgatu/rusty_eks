
locals {
  git_key_secret_name = "git-deploy-key"
  #should be deleted once is deployed
  git_seed_secret_name = "git-seed-key"
  git_key_path = {
    private = coalesce(var.deploy_key_path.private, "./git_private.pem")
    public  = coalesce(var.deploy_key_path.public, "./git_public.pem")
  }
}
data "local_file" "deploy_ssh_key" {
  filename   = local.git_key_path.private
  depends_on = [tls_private_key.git_key]
}
data "local_file" "seed_ssh_key" {
  filename = var.seed_key_path
}
