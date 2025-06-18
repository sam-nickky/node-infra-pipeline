variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "ami_id" {
  default = "ami-042b4708b1d05f512" 
}
variable "key_name" {
  default = "Project1"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "alb_target_group_arn" {}
variable "instance_profile" {}
variable "alb_sg_id" {}

