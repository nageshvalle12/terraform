# Create an IAM role for ECS task execution
resource "aws_iam_role" "datamigration_ecs_execution_role" {
  name = "${var.app-name}-${var.app-env}-ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    ENV = var.app-env
  }
}

# Create an IAM Policy for ECS task execution role
resource "aws_iam_policy" "datamigration_ecs_execution_policy" {
  name        = "${var.app-name}-${var.app-env}-ecs-execution-role-policy"
  description = "${var.app-name}-${var.app-env}-ecs-execution-role-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        "Resource" : "arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:repository/${var.app-name}-${var.app-env}-ecr"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${var.app-name}-${var.app-env}-task-definition:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:${var.app-name}-*"
        ]
      }
    ]
  })
  tags = {
    ENV = var.app-env
  }
}

# Attach ECS task execution policy to ECS task execution role
resource "aws_iam_policy_attachment" "ecs_execution_role_policy" {
  name       = "ecs_execution_role_policy_attachment"
  policy_arn = aws_iam_policy.datamigration_ecs_execution_policy.arn
  roles      = [aws_iam_role.datamigration_ecs_execution_role.name]
}

# Create an IAM role for Code Build
resource "aws_iam_role" "datamigration_codebuild_role" {
  name = "${var.app-name}-${var.app-env}-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    ENV = var.app-env
  }
}
# Create an IAM Policy for Code Build
resource "aws_iam_policy" "datamigration_codebuild_policy" {
  name        = "${var.app-name}-${var.app-env}-codebuild-role-policy"
  description = "${var.app-name}-${var.app-env}-codebuild-role-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "ec2:CreateNetworkInterfacePermission",
        "Resource" : "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:network-interface/*",
        "Condition" : {
          "StringEquals" : {
            "ec2:AuthorizedService" : "codebuild.amazonaws.com",
            "ec2:Subnet" : "${aws_subnet.private_subnets[*].id}"
            #"ec2:subnet" : "${var.subnet_ids}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${var.app-name}-${var.app-env}-codebuild-log-group:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchDeleteImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ],
        "Resource" : "arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:repository/${var.app-name}-${var.app-env}-ecr"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:${var.app-name}-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecs:RunTask",
          "ecs:DescribeTasks"
        ],
        "Resource" : [
          "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:cluster/${var.app-name}-${var.app-env}-cluster",
          "${aws_ecs_task_definition.datamigration_ecs_task_definition.arn}"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "iam:PassRole"
        ],
        "Resource": [
          "arn:aws:iam::${var.aws_account_id}:role/${var.app-name}-${var.app-env}-ecs-execution-role"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:CreateNetworkInterfacePermission"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
  tags = {
    ENV = var.app-env
  }
}

# Attach Code Build policy to Code Build role
resource "aws_iam_policy_attachment" "codebuild_role_policy" {
  name       = "code_build_policy_attachment"
  policy_arn = aws_iam_policy.datamigration_codebuild_policy.arn
  roles      = [aws_iam_role.datamigration_codebuild_role.name]
}
# Create an IAM role for Cloud Watch Event
resource "aws_iam_role" "datamigration_cloudwatch_event_role" {
  name = "${var.app-name}-${var.app-env}-cloudwatch-event-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "events.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    ENV = var.app-env
  }
}

# Create an IAM Policy for Cloud Watch
resource "aws_iam_policy" "datamigration_cloudwatch_event_policy" {
  name        = "${var.app-name}-${var.app-env}-cloudwatch-event-role-policy"
  description = "${var.app-name}-${var.app-env}-cloudwatch-event-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect": "Allow",
        "Action": [
          "codebuild:StartBuild"
        ],
        "Resource": "${aws_codebuild_project.datamigration_codebuild_project.arn}"
      }
    ]
  })
  tags = {
    ENV = var.app-env
  }
}

# Attach Code Build policy to Code Build role
resource "aws_iam_policy_attachment" "cloudwatch_event_role_policy" {
  name       = "cloudwatch_event_policy_attachment"
  policy_arn = aws_iam_policy.datamigration_cloudwatch_event_policy.arn
  roles      = [aws_iam_role.datamigration_cloudwatch_event_role.name]
}
