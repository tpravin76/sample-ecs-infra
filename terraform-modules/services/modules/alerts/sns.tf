resource "aws_sns_topic" "sns_topic" {
  name = "${var.app_name}-${var.app_environment}-ecs-task-change"
}

resource "aws_sns_topic_subscription" "sns_topic_target" {
  for_each  = toset(var.emails)
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = each.value
}