
resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_name}-${var.app_environment}-task"
  container_definitions = templatefile("${path.module}/task-definitions/service.json", {
    name = "${var.app_name}-${var.app_environment}-container"
    image = "${var.aws_ecr_repository_url}:latest"
    ENVIRONMENT = var.app_environment
    DYNAMODB_ACCESSKEY = var.DYNAMODB_ACCESSKEY
    DYNAMODB_ACCESSSECRET = var.DYNAMODB_ACCESSSECRET
    SF_USER = var.SF_USER
    SF_PASS = var.SF_PASS
    SF_CLIENT_ID = var.SF_CLIENT_ID
    SF_CLIENT_SECRET = var.SF_CLIENT_SECRET
    JWT_SECRET = var.JWT_SECRET
    ES_PRIMARY_USER = var.ES_PRIMARY_USER,
    ES_PRIMARY_PASS = var.ES_PRIMARY_PASS,
    DATADOG_API_KEY = var.DATADOG_API_KEY
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "4096"
  cpu                      = "2048"
  execution_role_arn       = var.ecsTaskExecutionRoleArn
  task_role_arn            = var.ecsTaskExecutionRoleArn

  tags = {
    Name        = "${var.app_name}-ecs-td"
    Environment = var.app_environment
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}