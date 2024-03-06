resource "aws_cloudwatch_log_group" "app_group" {
  name = var.aws_logs_group_name
}

resource "aws_cloudwatch_log_stream" "app_service_stream" {
  name           = var.ecs_container_name
  log_group_name = aws_cloudwatch_log_group.app_group.name
}

resource "aws_cloudwatch_log_stream" "db_migration_stream" {
  name           = var.ecs_db_migaration
  log_group_name = aws_cloudwatch_log_group.app_group.name
}