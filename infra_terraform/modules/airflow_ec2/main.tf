resource "aws_security_group" "ec2_airflow_sg" {
  name_prefix = "airflow"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "ec2_airflow" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_airflow_sg.id]
  key_name               = var.key_pair_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt -y install python3-pip
              sudo apt -y install sqlite3
              sudo apt -y install libpq-dev
              sudo pip3 install virtualenv
              python3 -m virtualenv  /home/ubuntu/venv
              source /home/ubuntu/venv/bin/activate
              pip install "apache-airflow[postgres]==2.5.0" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.5.0/constraints-3.7.txt"
              airflow db init
              sed -i 's#sqlite:////home/ubuntu/airflow/airflow.db#postgresql+psycopg2://${var.airflow_db_user}:${var.airflow_db_password}@${var.postgres_endpoint}:${var.postgres_port}/${var.postgres_db_name}#g' /home/ubuntu/airflow/airflow.cfg
              sed -i 's#SequentialExecutor#LocalExecutor#g' /home/ubuntu/airflow/airflow.cfg
              airflow db init
              airflow users create -u ${var.airflow_db_user} -f airflow -l airflow -r Admin -e airflow@gmail.com -p ${var.airflow_db_password}
              mkdir /home/ubuntu/dags
              sed -i 's/^dags_folder = .*/dags_folder = \/home\/ubuntu\/dags/' /home/ubuntu/airflow/airflow.cfg
              airflow db init
              airflow webserver &
              airflow scheduler
              EOF
}
