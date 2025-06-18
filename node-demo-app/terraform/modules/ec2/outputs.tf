output "asg_name" {
  value = aws_autoscaling_group.app_asg.name
}
output "instance_sg_id" {
  value = aws_security_group.app_sg.id
}

