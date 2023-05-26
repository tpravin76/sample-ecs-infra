resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_name}-${var.app_environment}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${var.app_name}-iam-role"
    Environment = var.app_environment
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy" "secret_policy_secretsmanager" {
  name = "secret-policy-secretsmanager"
  role = aws_iam_role.ecsTaskExecutionRole.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:secretsmanager:us-east-1:817832525236:secret:sch-api/qa/*",
          "arn:aws:secretsmanager:us-east-1:817832525236:secret:DdApiKeySecret*",
          "arn:aws:secretsmanager:us-west-2:817832525236:secret:sch-api/qa/*",
          "arn:aws:secretsmanager:us-west-2:817832525236:secret:DdApiKeySecret*"
        ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "ecs-read-metrics" {
  name = "${var.app_name}-${var.app_environment}-ecs-read-metrics"
  role = aws_iam_role.ecsTaskExecutionRole.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:Describe*",
            "ecs:Describe*",
            "ecs:List*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}
output "ecsTaskExecutionRoleArn" {
  value = aws_iam_role.ecsTaskExecutionRole.arn
}