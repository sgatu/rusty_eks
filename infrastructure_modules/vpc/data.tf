locals {
  private_subnet_tags = merge(var.private_subnet_tags, {
    Tier = "private"
  })
  public_subnet_tags = merge(var.public_subnet_tags, {
    Tier = "public"
  })
  database_subnet_tags = {
    Tier = "database"
  }
  security_group_module_version = "~> 4.17.2"
}
