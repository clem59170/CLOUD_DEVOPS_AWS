data "archive_file" "lambda_post_message" {
  type        = "zip"
  source_file = "post_message.py"
  output_path = "lambda_cyclone_post_message.zip"
}

resource "aws_lambda_function" "post_message" {
  filename         = "lambda_cyclone_post_message.zip"
  function_name    = "lambda-cyclone-post-message"
  handler          = "post_message.handler"
  runtime          = "python3.10"
  source_code_hash = data.archive_file.lambda_post_message.output_base64sha256

  role = "arn:aws:iam::144312316210:role/lambda-cyclone-role"

  tags = {
    Name        = "lambda-cyclone-post-message"
    Environment = "prod"
    Group       = "cyclone"
  }
}

data "archive_file" "lambda_fetch_messages" {
  type        = "zip"
  source_file = "fetch_messages.py"
  output_path = "lambda_cyclone_fetch_messages.zip"
}

resource "aws_lambda_function" "fetch_messages" {
  filename         = "lambda_cyclone_fetch_messages.zip"
  function_name    = "lambda-cyclone-fetch-messages"
  handler          = "fetch_messages.handler"
  runtime          = "python3.10"
  source_code_hash = data.archive_file.lambda_fetch_messages.output_base64sha256

  role = "arn:aws:iam::144312316210:role/lambda-cyclone-role"

  tags = {
    Name        = "lambda-cyclone-fetch-message"
    Environment = "prod"
    Group       = "cyclone"
  }
}