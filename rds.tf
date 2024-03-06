# RDS Instance for PostgreSQL
resource "aws_db_instance" "postgres_db" {
  identifier             = local.secret_RDS_DB_IDENTIFIER
  db_name                = local.secret_RDS_DB_NAME
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = var.rds_instance_class
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp3"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  username               = local.secret_RDS_USERNAME
  password               = local.secret_RDS_PASSWORD
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.shared_vpc.id
}

resource "aws_route_table_association" "rds_route_table_association_a" {
  subnet_id      = aws_subnet.rds_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rds_route_table_association_b" {
  subnet_id      = aws_subnet.rds_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "my-db-subnet-group"
  subnet_ids = [
    aws_subnet.rds_subnet_a.id,
    aws_subnet.rds_subnet_b.id,
  ]
}

resource "aws_subnet" "rds_subnet_a" {
  vpc_id            = aws_vpc.shared_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.shared_vpc.cidr_block, 8, 101)
  availability_zone = var.availability_zone_a
}

resource "aws_subnet" "rds_subnet_b" {
  vpc_id            = aws_vpc.shared_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.shared_vpc.cidr_block, 8, 102)
  availability_zone = var.availability_zone_b
}

resource "aws_security_group" "rds_sg" {
  name        = "my-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = aws_vpc.shared_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.default_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
