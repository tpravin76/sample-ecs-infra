resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.app_name}-${var.app_environment}-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = "${aws_ecs_task_definition.aws-ecs-task.family}:${max(aws_ecs_task_definition.aws-ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2

  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
    security_groups = [
      aws_security_group.service_security_group.id
#      aws_security_group.load_balancer_security_group.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}-${var.app_environment}-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.listener]
}

resource "aws_security_group" "service_security_group" {
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-service-sg"
    Environment = var.app_environment
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name        = "${var.app_name}-public-subnet-*"
    Environment = var.app_environment
  }
}

resource "aws_eip" "one" {
  domain   = "vpc"
  tags = {
    "Name" = "${var.app_name}-eip"
  }
}

resource "aws_eip" "two" {
  domain   = "vpc"
  tags = {
    "Name" = "${var.app_name}-eip"
  }
}

#resource "aws_eip" "lb" {
#  for_each = toset(aws_subnet.public.*.id)
#  domain   = "vpc"
#  tags = {
#    "Name" = "${var.app_name}-eip"
#  }
#}

#data "aws_eip" "by_tags" {
#  tags = {
#    Name = "${var.app_name}-eip"
#  }
#}
locals {
  subnets = aws_subnet.public.*.id
}
resource "aws_alb" "network_load_balancer" {
  name               = "${var.app_name}-${var.app_environment}-alb"
  internal           = false
  load_balancer_type = "network"
#  subnets            = aws_subnet.public.*.id

#  security_groups    = [aws_security_group.load_balancer_security_group.id]

#  dynamic "subnet_mapping" {
#    for_each = data.aws_eip.by_tags.association_id
#    content {
#      subnet_id     = subnet_mapping.value
#      allocation_id = aws_eip.lb[subnet_mapping.key].allocation_id
#    }
#  }

  subnet_mapping {
    subnet_id     = sort(local.subnets)[0]
    allocation_id = aws_eip.one.association_id
  }

  subnet_mapping {
    subnet_id     = sort(local.subnets)[1]
    allocation_id = aws_eip.two.association_id
  }

  tags = {
    Name        = "${var.app_name}-alb"
    Environment = var.app_environment
  }
  depends_on = [data.aws_subnets.public]
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_name}-sg"
    Environment = var.app_environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.app_environment}-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.vpc.id

#  stickiness {
#    type = "lb_cookie"
#    cookie_duration = 86400
#  }

  health_check {
    healthy_threshold   = "2"
    interval            = "60"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/health"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-lb-tg"
    Environment = var.app_environment
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.network_load_balancer.id
  port              = "80"
  protocol          = "TCP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

#resource "aws_lb_cookie_stickiness_policy" "stickiness_policy" {
#  name                     = "stickiness_policy"
#  load_balancer            = aws_alb.application_load_balancer.id
#  lb_port                  = 80
#  cookie_expiration_period = 600
#}
