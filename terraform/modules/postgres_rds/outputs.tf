output "posgtgres_db_endpoint" {
  value       = aws_db_instance.posgtgres_db.endpoint
  description = "The public endpoint name of the Postgres."
}

output "posgtgres_db_port" {
  value       = aws_db_instance.posgtgres_db.port
  description = "The public port name of the Postgres."
}