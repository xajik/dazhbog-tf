variable "app_ecr_repository_name" {
  description = "Service ECR repository"
  type        = string
  default     = "app-container"
}

resource "aws_ecr_repository" "my_repository" {
  name = var.app_ecr_repository_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "app_ecr_repository_url" {
  value = aws_ecr_repository.my_repository.repository_url
}

variable "db_ecr_repository_name" {
  description = "DB migration ECR repository"
  type        = string
  default     = "migration-container"
}

resource "aws_ecr_repository" "db_repository" {
  name = var.db_ecr_repository_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "migration_ecr_repository_url" {
  value = aws_ecr_repository.db_repository.repository_url
}


