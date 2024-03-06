resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id            = aws_vpc.shared_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecs-agent"
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id            = aws_vpc.shared_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecs-telemetry"
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = aws_vpc.shared_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecs"
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.shared_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.shared_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
}