resource "aws_ecs_cluster" "ecs-cluster" {
  name = "dp-cluster"
  tags = {
    Name = "dp-cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs-provider" {
  cluster_name       = aws_ecs_cluster.ecs-cluster.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }
}

data "aws_iam_role" "ecs-execution-role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_service" "ecs-service" {
  name    = "dp-ecs-service"
  cluster = aws_ecs_cluster.ecs-cluster.arn

  //not specifying capacity provider strategy - using the default strategy associated with the cluster
  desired_count   = 1
  task_definition = aws_ecs_task_definition.ecs-task-def.arn

  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 1
  }

  force_new_deployment = true

  network_configuration {
    subnets          = var.public-subnet-ids
    security_groups  = var.app-sg-ids
    assign_public_ip = true
  }

  health_check_grace_period_seconds = 30

  load_balancer {
    container_name   = "dp-container"
    container_port   = var.server-port
    target_group_arn = var.target-grp-arn
  }
}

resource "aws_ecs_task_definition" "ecs-task-def" {
  family = "dp-family"
  container_definitions = jsonencode([{
    name  = "dp-container"
    image = var.docker-image
    portMappings = [{
      containerPort = var.server-port
      hostPort      = var.server-port
    }]
    environment = [{
      name  = "hibernate_host"
      value = var.db-host
      },
      {
        name  = "hibernate_connection_password"
        value = var.db-password
      },
      {
        name  = "hibernate_connection_username"
        value = var.db-username
      },
      {
        name  = "port"
        value = tostring(var.server-port)
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/Dp"
        awslogs-region        = "${var.aws-region}",
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
  cpu          = "1024"
  memory       = "3072"
  network_mode = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  execution_role_arn = data.aws_iam_role.ecs-execution-role.arn

}