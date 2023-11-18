output "posgtgres_db_endpoint" {
  value       = module.postgres_rds.posgtgres_db_endpoint
  description = "The public endpoint name of the Postgres."
}

output "posgtgres_db_port" {
  value       = module.postgres_rds.posgtgres_db_port
  description = "The public port name of the Postgres."
}

output "public_airflow_ip" {
  value       = module.airflow_ec2.public_airflow_ip
  description = "The public IP address of the EC2 airflow instance."
}

output "public_airflow_dns" {
  value       = module.airflow_ec2.public_airflow_dns
  description = "The public DNS name of the EC2 airflow instance."
}