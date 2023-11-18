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