# Create Code Build project for Data Runner CICD setup

data "local_file" "datamigration_buildspec_local" {
  filename = "./buildspec.yml"
}

resource "aws_codebuild_project" "datamigration_codebuild_project" {
  name           = "${var.app-name}-${var.app-env}-codebuild-project"
  description    = "ECS CodeBuild Project"
  service_role   = aws_iam_role.datamigration_codebuild_role.arn
  build_timeout  = 50
  queued_timeout = 5
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "REPOSITORY_NAME"
      value = aws_ecr_repository.datamigration_ecr.name
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = var.image_tag
    }
    environment_variable {
      name  = "GITHUB_SSH_KEY_SECRET"
      value = aws_secretsmanager_secret.datamigration_github_private_key.name
    }
    environment_variable {
      name  = "GITHUB_SSH_URL"
      value = var.github_ssh_url
    }
    environment_variable {
      name  = "GITHUB_BRANCH"
      value = var.github_branch
    }
    environment_variable {
      name  = "CLUSTER_NAME"
      value = aws_ecs_cluster.datamigration_ecs_cluster.name
    }
    environment_variable {
      name  = "TASK_DEFINITION"
      value = aws_ecs_task_definition.datamigration_ecs_task_definition.arn
    }
    environment_variable {
      name  = "PRIVATE_SUBNET_1"
      value = aws_subnet.private_subnets[0].id
    }
    environment_variable {
      name  = "PRIVATE_SUBNET_2"
      value = aws_subnet.private_subnets[1].id
    }
    environment_variable {
      name  = "SECURITY_GROUP"
      value = aws_security_group.datamigration_ecs_security_group.id
    }
    privileged_mode = true
  }
  source {
    type      = "NO_SOURCE"
    buildspec = data.local_file.datamigration_buildspec_local.content
  }
  source_version = var.github_branch
  artifacts {
    type = "NO_ARTIFACTS"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.app-name}-${var.app-env}-codebuild-log-group"
      stream_name = "codebuild"
    }
  }
  vpc_config {
    #vpc_id      = var.vpc_id
    #subnets        = var.subnet_ids
    vpc_id             = aws_vpc.data_runner_vpc.id
    subnets            = aws_subnet.private_subnets[*].id
    security_group_ids = [aws_security_group.datamigration_ecs_security_group.id]
  }

  tags = {
    ENV = var.app-env
  }
}
