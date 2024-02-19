# Create Data Runner ECS Cluster
resource "aws_ecs_cluster" "datamigration_ecs_cluster" {
  name = "${var.app-name}-${var.app-env}-cluster"
  tags = {
    ENV = var.app-env
  }
}

# Create Data Runner ECS Task Definition
resource "aws_ecs_task_definition" "datamigration_ecs_task_definition" {
  family                   = "${var.app-name}-${var.app-env}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.datamigration_ecs_execution_role.arn
  execution_role_arn       = aws_iam_role.datamigration_ecs_execution_role.arn
  memory                   = var.ecs_memory
  cpu                      = var.ecs_cpu
  container_definitions = jsonencode([
    {
      name      = "${var.app-name}-${var.app-env}-container"
      image     = "${aws_ecr_repository.datamigration_ecr.repository_url}:${var.image_tag}"
      memory    = "${var.ecs_memory}"
      cpu       = "${var.ecs_cpu}"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${var.app-name}-${var.app-env}-task-definition"
          awslogs-region        = "${var.aws_region}"
          awslogs-stream-prefix = "ecs"
          awslogs-create-group  = "true"
        }
      }
    }
  ])
  tags = {
    ENV = var.app-env
  }
}
