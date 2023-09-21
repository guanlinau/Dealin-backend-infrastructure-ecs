# Create IAM ECS Task Execution Role at first time 
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.task_execution_role_name
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

# Create IAM ECS task role
resource "aws_iam_role" "ecs_task_role" {
  name = var.task_role_name
 
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
       "logs:CreateLogGroup",
      "logs:PutLogEvents",
       "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "cloudwatch:PutMetricData",
       "ssm:GetParameter"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "AmazonECSTaskExecutionRolePolicy"
  description = "AmazonECSTaskExecutionRolePolicy"
  policy      = data.aws_iam_policy_document.policy.json
}

# Attach the ECS task role policy to the ECS task role
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.ecs_task_role.name
}

# Attach the ECS task execution role policy to the ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}