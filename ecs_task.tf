resource "aws_ecs_task_definition" "rust_service" {
  family                   = var.ecs_container_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "512"  # 0.5 vCPU
  memory                   = "1024" # 1024 MB

  container_definitions = jsonencode([
    {
      name      = var.ecs_db_migaration
      cpu       = 256
      memory    = 512
      essential = false
      image     = "${aws_ecr_repository.db_repository.repository_url}:latest"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = aws_cloudwatch_log_stream.db_migration_stream.name
        }
      }
      environment = [
        {
          name  = "DATABASE_URL"
          value = "postgres://${local.secret_RDS_USERNAME}:${local.secret_RDS_PASSWORD}@${aws_db_instance.postgres_db.endpoint}/${local.secret_RDS_DB_NAME}"
        },
      ]
    },
    {
      name      = var.ecs_container_name
      cpu       = 256
      memory    = 512
      essential = true
      image     = "${aws_ecr_repository.my_repository.repository_url}:latest"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = aws_cloudwatch_log_stream.app_service_stream.name
        }
      },
      portMappings = [
        {
          containerPort = 3001
          hostPort      = 3001
          protocol      = "tcp"
        }
      ],
      depends_on = [
        {
          containerName = var.ecs_db_migaration
          condition     = "SUCCESS"
        }
      ],
      environment = [
        {
          name  = "DATABASE_URL"
          value = "postgres://${local.secret_RDS_USERNAME}:${local.secret_RDS_PASSWORD}@${aws_db_instance.postgres_db.endpoint}/${local.secret_RDS_DB_NAME}"
        },
        {
          name  = "JWT_ACCESS_SECRET"
          value = local.secret_JWT_ACCESS_SECRET
        },
        {
          name  = "JWT_REFRESH_SECRET"
          value = local.secret_JWT_REFRESH_SECRET
        },
        {
          name  = "OPEN_AI_API_KEY"
          value = local.secret_OPEN_AI_API_KEY
        },
        {
          name  = "CLOUDFLARE_AI_API_KEY"
          value = local.secret_CLOUDFLARE_AI_API_KEY
        },
        {
          name  = "CLOUDFLARE_ACCOUNT"
          value = local.secret_CLOUDFLARE_ACCOUNT
        },
        {
          name  = "GOOGLE_VISION_API_KEY"
          value = local.secret_GOOGLE_VISION_API_KEY
        },
        {
          name  = "GOOGLE_PALM2_API_KEY"
          value = local.secret_GOOGLE_PALM2_API_KEY
        },
      ]
    }
  ])
}

resource "aws_ecs_service" "app_service" {

  depends_on = [aws_lb.app_lb]

  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.rust_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = aws_lb_target_group.app_target_group.arn
    container_name   = var.ecs_container_name
    container_port   = 3001
  }

  network_configuration {
    subnets = [
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id
    ]
    security_groups = [
      aws_security_group.default_sg.id,
    ]
    assign_public_ip = true
  }
}

resource "aws_lb_target_group" "app_target_group" {
  name        = "app-tg"
  port        = 3001
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.shared_vpc.id

  health_check {
    path                = "/api/ping"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 120
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_lb_listener" "app_ssl_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.getthedeck.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }

}

resource "aws_lb_listener_rule" "getthedeck_rule" {
  listener_arn = aws_lb_listener.app_ssl_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
  condition {
    host_header {
      values = [var.getthedeck_api_domain]
    }
  }
}
