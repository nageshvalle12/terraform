# Create AWS Secret manager to store Private Key for GitHub
resource "aws_secretsmanager_secret" "datamigration_github_private_key" {
  name        = "${var.app-name}-GitHubPrivateKey13"
  description = "GitHub SSH Private Keys"
}
