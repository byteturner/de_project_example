data "aws_vpc" "default" {
  default = true
}

module "postgres_rds" {
  source              = "../../modules/postgres_rds"
  vpc_id              = data.aws_vpc.default.id
  db_airflow_password = var.db_airflow_password
  db_airflow_user     = var.db_airflow_user
}

module "airflow_ec2" {
  source     = "../../modules/airflow_ec2"
  depends_on = [module.postgres_rds]
  vpc_id     = data.aws_vpc.default.id
  key_pair_name = var.key_pair_name
  airflow_db_password = var.db_airflow_password
  airflow_db_user = var.db_airflow_user
  postgres_endpoint = module.postgres_rds.posgtgres_db_endpoint
  postgres_port = module.postgres_rds.posgtgres_db_port
}