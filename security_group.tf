# ECS security group which ecs task will use
resource "aws_security_group" "datamigration_ecs_security_group" {
  name        = "${var.app-name}-${var.app-env}-ecs-security-group"
  description = "ECS Security Group"
  vpc_id      = aws_vpc.data_runner_vpc.id
  #vpc_id      = var.vpc_id

  # Default inbound and outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    ENV = var.app-env
  }
}
