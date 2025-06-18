resource "aws_db_subnet_group" "this" {
  name       = "app-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "App DB Subnet Group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow traffic from EC2 only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id]  # Allow from EC2 SG only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "nodeapp-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  publicly_accessible     = false
  multi_az                = false
  storage_encrypted       = true
  backup_retention_period = 7

  tags = {
    Name = "nodeapp-rds"
  }
}

