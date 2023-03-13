
resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_name}-task"
  container_definitions = templatefile("task-definitions/service.json", {
    name = "${var.app_name}-${var.app_environment}-container"
    image = "${aws_ecr_repository.aws-ecr.repository_url}:latest"
    awslogs-group = aws_cloudwatch_log_group.log-group.id
    region = var.aws_region
    logs-prefix = "${var.app_name}-${var.app_environment}"
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn


  tags = {
    Name        = "${var.app_name}-ecs-td"
    Environment = var.app_environment
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}