resource "aws_sns_topic" "sns_topic" {
  name = "ecs-task-change"
}

resource "aws_sns_topic_subscription" "sns_topic_target" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = "pravin.taralkar@languageline.com"
}