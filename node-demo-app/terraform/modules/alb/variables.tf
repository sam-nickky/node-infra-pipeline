variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "target_group_port" {
  type    = number
  default = 3000
}

