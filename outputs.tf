output "vpc_id" {
  value       = aws_vpc.shared_vpc.id
  description = "The ID of the VPC"
}

output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
  description = "The DNS name of the ALB"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.app_cluster.name
  description = "The name of the ECS Cluster"
}
output "ecs_service_name" {
  value       = aws_ecs_service.app_service.name
  description = "value of the ECS service name"
}

output "rds_endpoint" {
  value       = aws_db_instance.postgres_db.endpoint
  description = "The port of the RDS instance"
}

output "website_bucket_name" {
  value = aws_s3_bucket.app_website_bucket.bucket
}

output "website_bucket_regional_domain_name" {
  value = aws_s3_bucket.app_website_bucket.bucket_regional_domain_name
}

output "website_distribution" {
  value = aws_cloudfront_distribution.website_distribution.domain_name
}