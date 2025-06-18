variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "db_name" {
  default = "nodeapp"
}

variable "db_username" {
  default = "dbadmin"
}

variable "db_password" {
  default = "SaMAkkina!223"
}

variable "ec2_sg_id" {}

