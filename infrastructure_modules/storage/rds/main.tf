module "rds" {
  source                            = "terraform-aws-modules/rds-aurora/aws"
  name                              = var.identifier
  engine                            = "aurora-mysql"
  engine_version                    = var.mysql_version
  database_name                     = var.db_name
  manage_master_user_password       = false
  master_username                   = var.username
  master_password                   = var.password
  apply_immediately                 = false
  create_db_cluster_parameter_group = true
  db_cluster_parameter_group_name   = var.identifier
  db_cluster_parameter_group_family = "aurora-mysql${var.mysql_version}"
  create_db_subnet_group            = true
  db_subnet_group_name              = var.subnet_group_name
  subnets                           = var.subnet_ids
  vpc_security_group_ids            = [var.security_group]
  availability_zones                = var.availability_zones
  vpc_id                            = var.vpc_id
  skip_final_snapshot               = true
  publicly_accessible               = true
  instances = {
    1 = {
      instance_class = var.instance_class
    }
  }
  db_cluster_parameter_group_parameters = [
    {
      name  = "character_set_client"
      value = var.charset
    },
    {
      name  = "character_set_server"
      value = var.charset
    }
  ]
}
