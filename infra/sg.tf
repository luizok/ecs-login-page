resource "aws_security_group" "public_alb_sg" {
  name        = "${var.project_name}-public-to-alb"
  description = "Public ALB security group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "Allow HTTP public traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP public traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-public-to-alb"
  }
}

resource "aws_security_group" "albsg_ecs_sg" {
  name        = "${var.project_name}-alb-to-ecs"
  description = "Private security group from ALB to ECS"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description     = "Allow private traffic between ALB and ECSon port 80"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.public_alb_sg.id]
  }

  ingress {
    description = "Allow private traffic between ALB and ECSon port 80"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-to-ecs"
  }
}
