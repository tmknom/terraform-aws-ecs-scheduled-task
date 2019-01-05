module "ecs_scheduled_task" {
  source                = "../../"
  name                  = "example"
  schedule_expression   = "rate(3 minutes)"
  container_definitions = "${data.template_file.default.rendered}"
  cluster_arn           = "${aws_ecs_cluster.example.arn}"
  subnets               = ["${module.vpc.public_subnet_ids}"]

  ecs_task_execution_policy = "${data.aws_iam_policy.ecs_task_execution.policy}"
  is_enabled                = true
  task_count                = 1
  platform_version          = "1.3.0"
  assign_public_ip          = true
  security_groups           = []
  cpu                       = 256
  memory                    = 512
  requires_compatibilities  = ["FARGATE"]
  iam_path                  = "/service_role/"
  description               = "This is example"
  enabled                   = true

  tags = {
    Environment = "prod"
  }
}

data "template_file" "default" {
  template = "${file("${path.module}/container_definitions.json")}"

  vars {
    awslogs_region = "${data.aws_region.current.name}"
    awslogs_group  = "${local.awslogs_group}"
  }
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "${local.awslogs_group}"
  retention_in_days = 1
}

locals {
  awslogs_group = "/ecs-scheduled-task/example"
}

resource "aws_ecs_cluster" "example" {
  name = "ecs-scheduled-task"
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "vpc" {
  source                    = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/1.0.0"
  cidr_block                = "${local.cidr_block}"
  name                      = "ecs-scheduled-task"
  public_subnet_cidr_blocks = ["${cidrsubnet(local.cidr_block, 8, 0)}", "${cidrsubnet(local.cidr_block, 8, 1)}"]
  public_availability_zones = ["${data.aws_availability_zones.available.names}"]
}

locals {
  cidr_block = "10.255.0.0/16"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
