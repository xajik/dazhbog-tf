variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "cidr_block_internet" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "0.0.0.0/0"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone_a" {
  description = "Availability Zone for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  description = "Availability Zone for the subnet"
  type        = string
  default     = "us-east-1b"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  default     = "ecs-app-cluster"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "ecs_db_migaration" {
  description = "ECS container name"
  type        = string
  default     = "ecs_db_migaration"
}
variable "ecs_container_name" {
  description = "ECS container name"
  type        = string
  default     = "rust-service"
}

variable "aws_logs_group_name" {
  description = "ECS service name"
  type        = string
  default     = "app-logs-rust-service"
}

variable "aws_logs_group_prefix" {
  description = "ECS service name"
  type        = string
  default     = "ecs-app"
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
  default     = "app-service"
}

variable "getthedeck_api_domain" {
  description = "Get The Deck API Domain"
  type        = string
  default     = "api.getthedeck.com"
}