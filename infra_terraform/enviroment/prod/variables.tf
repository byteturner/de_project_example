variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "db_airflow_user" {
  type = string
}

variable "db_airflow_password" {
  type = string
}