output "public_airflow_ip" {
  value       = aws_instance.ec2_airflow.public_ip
  description = "The public IP address of the EC2 airflow instance."
}

output "public_airflow_dns" {
  value       = aws_instance.ec2_airflow.public_dns
  description = "The public DNS name of the EC2 airflow instance."
}