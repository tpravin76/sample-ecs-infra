resource "aws_cloudwatch_event_rule" "capture-ecs-task-status" {
  name        = "${var.app_name}-${var.app_environment}-capture-ecs-task-status"
  description = "Capture data when tasks or container instances change."

  event_pattern = jsonencode({
    source: ["aws.ecs"],
    detail-type = [
      "ECS Deployment State Change",
      "ECS Task State Change",
      "ECS Container Instance State Change"
    ]
  })
}

resource "aws_cloudwatch_event_target" "event_target_lambda" {
  rule      = aws_cloudwatch_event_rule.capture-ecs-task-status.name
  arn       = aws_lambda_function.lambda_function.arn
}
