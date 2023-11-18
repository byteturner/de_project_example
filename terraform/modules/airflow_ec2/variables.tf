variable "vpc_id" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "ami" {
  type = string
  default = "ami-06dd92ecc74fdfb36"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "airflow_db_user" {
  type = string
}

variable "airflow_db_password" {
  type = string
}

variable "postgres_endpoint" {
  type = string
}

variable "postgres_port" {
  type = string
}

variable "postgres_db_name" {
  type = string
  default = "airflow"
}