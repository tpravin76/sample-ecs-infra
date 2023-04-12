
resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_name}-task"
  container_definitions = templatefile("task-definitions/service.json", {
    name = "${var.app_name}-${var.app_environment}-container"
    image = "${aws_ecr_repository.aws-ecr.repository_url}:latest"
    awslogs-group = aws_cloudwatch_log_group.log-group.id
    region = var.aws_region
    logs-prefix = "${var.app_name}-${var.app_environment}"
    SF_USER = var.SF_USER
    SF_PASS = var.SF_PASS
    SF_SANDBOX = var.SF_SANDBOX
    SF_CLIENT_ID = var.SF_CLIENT_ID
    SF_CLIENT_SECRET = var.SF_CLIENT_SECRET
    ES_PASS = var.ES_PASS
    REPLICATE_PASS = var.REPLICATE_PASS,
    DATADOG_API_KEY = var.DATADOG_API_KEY
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "4096"
  cpu                      = "2048"
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