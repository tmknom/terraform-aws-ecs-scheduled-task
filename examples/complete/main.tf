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

  ecs_task_role_arn    = aws_iam_role.ecs_task.arn
  
  tags = {
    Environment = "prod"
  }
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
