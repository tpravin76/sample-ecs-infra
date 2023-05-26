data "aws_iam_policy_document" "lambda-policy-document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda-inline-role-policy" {
  name = "${var.app_name}-${var.app_environment}-lambda-inline-role-policy"
  role = aws_iam_role.lambda-role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "lambda:InvokeFunction",
          "cloudwatch:PutMetricData"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "logs:*"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "sns:Publish"
        ],
        "Resource" : aws_sns_topic.sns_topic.arn,
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "lambda-role" {
  name               = "${var.app_name}-${var.app_environment}-lambda-role1"
  assume_role_policy = data.aws_iam_policy_document.lambda-policy-document.json
}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename      = "lambda_function.zip"
  function_name = "${var.app_name}-${var.app_environment}-alert-lambda-function"
  role          = aws_iam_role.lambda-role.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256

  environment {
    variables = {
      sns_arn = aws_sns_topic.sns_topic.arn
    }
  }

  runtime = "python3.8"
  depends_on = [data.archive_file.python_lambda_package]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.capture-ecs-task-status.arn
}