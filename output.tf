# data runner ecr repository url
output "ecr_uri" {
  value = aws_ecr_repository.datamigration_ecr.repository_url
}

# data runner ecr repository arn
output "ecr_arn" {
  value = aws_ecr_repository.datamigration_ecr.arn
}

# data runner ecs cluster name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.datamigration_ecs_cluster.name
}

# data runner ecs cluster name
output "ecs_cluster_arn" {
  value = aws_ecs_cluster.datamigration_ecs_cluster.arn
}

# data runner ecs task definition arn
output "task_definition_arn" {
  value = aws_ecs_task_definition.datamigration_ecs_task_definition.arn
}

# data runner code build project id
output "codebuild_project_id" {
  value = aws_codebuild_project.datamigration_codebuild_project.id
}

# data runner code build project arn
output "codebuild_project_arn" {
  value = aws_codebuild_project.datamigration_codebuild_project.arn
}

# ARN ECS Task Execution Role
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.datamigration_ecs_execution_role.arn
}

# ARN CodeBuild Role
output "codebuild_role_arn" {
  value = aws_iam_role.datamigration_codebuild_role.arn
}

# ARN CloudWatch Event Role
output "cloudwatch_role_arn" {
  value = aws_iam_role.datamigration_cloudwatch_event_role.arn
}

# ARN Secret Manager GitHub

output "secret_github_arn" {
  value = aws_secretsmanager_secret.datamigration_github_private_key.arn
}
