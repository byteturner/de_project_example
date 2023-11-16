module "postgres_rds" {
  source = "../../modules/postgres_rds"
}

module "airflow_ec2" {
  source = "../../modules/airflow_ec2"
}