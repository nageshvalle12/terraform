# Create Data Runner Elastic Container Repository
resource "aws_ecr_repository" "datamigration_ecr" {
  name                 = "${var.app-name}-${var.app-env}-ecr"
  force_delete         = var.force_delete
  image_tag_mutability = var.image_tag_mutability
  encryption_configuration {
    encryption_type = var.ecr_encryption_type
  }
  image_scanning_configuration {
    scan_on_push = var.ecr_scanning
  }
  tags = {
    ENV = var.app-env
  }
}
