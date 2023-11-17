output "posgtgres_db_endpoint" {
  value       = module.postgres_rds.posgtgres_db_endpoint
  description = "The public endpoint name of the Postgres."
}

output "posgtgres_db_port" {
  value       = module.postgres_rds.posgtgres_db_port
  description = "The public port name of the Postgres."
}