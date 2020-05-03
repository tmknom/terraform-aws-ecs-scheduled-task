module "ecs_scheduled_task" {
  source              = "../../"
  name                = "example"
  schedule_expression = "rate(3 minutes)"
  cluster_arn         = aws_ecs_cluster.example.arn
  subnets             = module.vpc.public_subnet_ids

  container_definitions = jsonencode([
    {
      name      = "alpine"
      image     = "alpine:latest"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = local.awslogs_group
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "date"
        }
      }
      command = ["/bin/date"]
    }
  ])

  is_enabled               = true
  task_count               = 1
  platform_version         = "LATEST"
  assign_public_ip         = true
  security_groups          = []
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  iam_path                 = "/service_role/"
  description              = "This is example"
  enabled                  = true

  create_ecs_events_role = false
  ecs_events_role_arn    = aws_iam_role.ecs_events.arn

  create_ecs_task_execution_role = false
  ecs_task_execution_role_arn    = aws_iam_role.ecs_task_execution.arn

  tags = {
    Environment = "prod"
  }
}

resource "aws_iam_role" "ecs_events" {
  name               = "ecs-events-for-ecs-scheduled-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_events_assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_events_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_events" {
  name   = aws_iam_role.ecs_events.name
  policy = data.aws_iam_policy.ecs_events.policy
}

data "aws_iam_policy" "ecs_events" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

resource "aws_iam_role_policy_attachment" "ecs_events" {
  role       = aws_iam_role.ecs_events.name
  policy_arn = aws_iam_policy.ecs_events.arn
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "ecs-task-execution-for-ecs-scheduled-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_task_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_task_execution" {
  name   = aws_iam_role.ecs_task_execution.name
  policy = data.aws_iam_policy.ecs_task_execution.policy
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution.arn
}

resource "aws_cloudwatch_log_group" "example" {
  name              = local.awslogs_group
  retention_in_days = 1
}

locals {
  awslogs_group = "/ecs-scheduled-task/example"
}

resource "aws_ecs_cluster" "example" {
  name = "ecs-scheduled-task"
}

module "vpc" {
  source                    = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/2.0.1"
  cidr_block                = local.cidr_block
  name                      = "ecs-scheduled-task"
  public_subnet_cidr_blocks = [cidrsubnet(local.cidr_block, 8, 0), cidrsubnet(local.cidr_block, 8, 1)]
  public_availability_zones = data.aws_availability_zones.available.names
}

locals {
  cidr_block = "10.255.0.0/16"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
