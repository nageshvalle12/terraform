variable "aws_account_id" {
  description = "AWS account id for the application"
  type        = string
  default     = "111446244270"
}
variable "aws_region" {
  description = "AWS Region for the infrastructure"
  type        = string
  default     = "ap-south-1"
}
variable "app-name" {
  description = "Application name of AWS infrastructure"
  type        = string
  default     = "dd-data-migration"
}
variable "app-env" {
  description = "Application environment of AWS infrastructure"
  type        = string
  default     = "dev"
}
variable "subnet_ids" {
  description = "Subnet IDs for ECS"
  type        = list(string)
  default     = ["subnet-06ae65583677b7d33", "subnet-0ebccf509706ab5a5"]
}
variable "vpc_id" {
  description = "VPC IDs to create ECS security group"
  type        = string
  default     = "vpc-0ce95b8049055a9ba"
}
variable "force_delete" {
  description = "Data Runner ECR force delete"
  type        = bool
  default     = true
}
variable "image_tag_mutability" {
  description = "Data Runner ECR image tag mutability"
  type        = string
  default     = "MUTABLE"
}
variable "ecr_encryption_type" {
  description = "Data Runner ECR encryption type"
  type        = string
  default     = "AES256"
}
variable "ecr_scanning" {
  description = "Data Runner ECR scanning"
  type        = bool
  default     = false
}
variable "image_tag" {
  description = "Data Runner ECR image tag"
  type        = string
  default     = "latest"
}
variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}
variable "public_subnet_cidr_a" {
  description = "CIDR range for the public subnet az-a"
  type        = string
  default     = "192.168.1.0/24"
}
variable "public_subnet_cidr_b" {
  description = "CIDR range for the public subnet az-b"
  type        = string
  default     = "192.168.2.0/24"
}
variable "private_subnet_cidr_a" {
  description = "CIDR range for the private subnet az-b"
  type        = string
  default     = "192.168.3.0/24"
}
variable "private_subnet_cidr_b" {
  description = "CIDR range for the private subnet az-b"
  type        = string
  default     = "192.168.4.0/24"
}
variable "github_private_key" {
  description = "GitHub SSH Private Key"
  type        = string
  sensitive   = true
  default     = ""
}
variable "github_ssh_url" {
  description = "GitHub SSH URL"
  type = string
  default = "git@github.com:nageshvalle/Data-Migration.git"
}
variable "github_branch" {
  description = "GitHub Branch"
  type = string
  default = "staging"
}
variable "ecs_cpu" {
  description = "ECS Task CPU"
  type = number
  default = 256
}
variable "ecs_memory" {
  description = "ECS Task Memory"
  type = number
  default = 512
}
