resource "aws_launch_template" "app" {
  name_prefix   = "node-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

#  iam_instance_profile {
#    name = var.instance_profile
#  }

#  user_data = base64encode(file("${path.module}/user-data.sh"))

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.private_subnet_ids
  target_group_arns    = [var.alb_target_group_arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "node-app-instance"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node-app-sg"
  }
}

