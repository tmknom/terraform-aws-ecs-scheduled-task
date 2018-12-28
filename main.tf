# Terraform module which creates ECS Scheduled Task resources on AWS.
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/scheduled_tasks.html

# CloudWatch Events IAM Role
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/CWE_IAM_role.html

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "ecs_events" {
  name               = "${local.ecs_events_iam_name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_events_assume_role_policy.json}"
  path               = "${var.iam_path}"
  description        = "${var.description}"
  tags               = "${merge(map("Name", local.ecs_events_iam_name), var.tags)}"
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

# https://www.terraform.io/docs/providers/aws/r/iam_policy.html
resource "aws_iam_policy" "ecs_events" {
  name        = "${local.ecs_events_iam_name}"
  policy      = "${data.aws_iam_policy.aws_ecs_events_role.policy}"
  path        = "${var.iam_path}"
  description = "${var.description}"
}

data "aws_iam_policy" "aws_ecs_events_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "ecs_events" {
  role       = "${aws_iam_role.ecs_events.name}"
  policy_arn = "${aws_iam_policy.ecs_events.arn}"
}

locals {
  ecs_events_iam_name = "${var.name}-ecs-events"
}

# ECS Task Definitions
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html

# https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html
resource "aws_ecs_task_definition" "default" {
  # A unique name for your task definition.
  family = "${var.name}"

  # The ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn = "${aws_iam_role.ecs_task_execution.arn}"

  # A list of container definitions in JSON format that describe the different containers that make up your task.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definitions
  container_definitions = "${var.container_definitions}"

  # The number of CPU units used by the task.
  # It can be expressed as an integer using CPU units, for example 1024, or as a string using vCPUs, for example 1 vCPU or 1 vcpu.
  # String values are converted to an integer indicating the CPU units when the task definition is registered.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
  cpu = "${var.cpu}"

  # The amount of memory (in MiB) used by the task.
  # It can be expressed as an integer using MiB, for example 1024, or as a string using GB, for example 1GB or 1 GB.
  # String values are converted to an integer indicating the MiB when the task definition is registered.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
  memory = "${var.memory}"

  # The launch type that the task is using.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#requires_compatibilities
  requires_compatibilities = ["${var.requires_compatibilities}"]

  # Fargate infrastructure support the awsvpc network mode.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#network_mode
  network_mode = "awsvpc"

  # A mapping of tags to assign to the resource.
  tags = "${merge(map("Name", var.name), var.tags)}"
}

# ECS Task Execution IAM Role
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${local.ecs_task_execution_iam_name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json}"
  path               = "${var.iam_path}"
  description        = "${var.description}"
  tags               = "${merge(map("Name", local.ecs_task_execution_iam_name), var.tags)}"
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

# https://www.terraform.io/docs/providers/aws/r/iam_policy.html
resource "aws_iam_policy" "ecs_task_execution" {
  name        = "${local.ecs_task_execution_iam_name}"
  policy      = "${var.ecs_task_execution_policy}"
  path        = "${var.iam_path}"
  description = "${var.description}"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = "${aws_iam_role.ecs_task_execution.name}"
  policy_arn = "${aws_iam_policy.ecs_task_execution.arn}"
}

locals {
  ecs_task_execution_iam_name = "${var.name}-ecs-task-execution"
}
