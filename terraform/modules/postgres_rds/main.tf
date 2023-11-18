resource "aws_security_group" "postgres_db_sg" {
  name_prefix = "postgres_db"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "posgtgres_db" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11"
  instance_class         = "db.t2.micro"
  db_name                = "airflow"
  username               = var.db_airflow_user
  password               = var.db_airflow_password
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.postgres_db_sg.id]
  skip_final_snapshot    = true
  multi_az               = false
}