# Terraform module which creates ECS Scheduled Task resources on AWS.
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/scheduled_tasks.html

# https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_rule.html
resource "aws_cloudwatch_event_rule" "default" {
  count = var.enabled ? 1 : 0

  name        = var.name
  description = var.description
  is_enabled  = var.is_enabled

  # All scheduled events use UTC time zone and the minimum precision for schedules is 1 minute.
  # CloudWatch Events supports Cron Expressions and Rate Expressions
  # For example, "cron(0 20 * * ? *)" or "rate(5 minutes)".
  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
  schedule_expression = var.schedule_expression
}

# https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_target.html
resource "aws_cloudwatch_event_target" "default" {
  count = var.enabled ? 1 : 0

  target_id = var.name
  arn       = var.cluster_arn
  rule      = aws_cloudwatch_event_rule.default[0].name
  role_arn  = var.create_ecs_events_role ? join("", aws_iam_role.ecs_events.*.arn) : var.ecs_events_role_arn

  # Contains the Amazon ECS task definition and task count to be used, if the event target is an Amazon ECS task.
  # https://docs.aws.amazon.com/AmazonCloudWatchEvents/latest/APIReference/API_EcsParameters.html
  ecs_target {
    launch_type         = "FARGATE"
    task_count          = var.task_count
    task_definition_arn = aws_ecs_task_definition.default[0].arn

    # Specifies the platform version for the task. Specify only the numeric portion of the platform version, such as 1.1.0.
    # This structure is used only if LaunchType is FARGATE.
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html
    platform_version = var.platform_version

    # This structure specifies the VPC subnets and security groups for the task, and whether a public IP address is to be used.
    # This structure is relevant only for ECS tasks that use the awsvpc network mode.
    # https://docs.aws.amazon.com/AmazonCloudWatchEvents/latest/APIReference/API_AwsVpcConfiguration.html
    network_configuration {
      assign_public_ip = var.assign_public_ip

      # Specifies the security groups associated with the task. These security groups must all be in the same VPC.
      # You can specify as many as five security groups. If you do not specify a security group,
      # the default security group for the VPC is used.
      security_groups = var.security_groups

      # Specifies the subnets associated with the task. These subnets must all be in the same VPC.
      # You can specify as many as 16 subnets.
      subnets = var.subnets
    }
  }
}

# CloudWatch Events IAM Role
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/CWE_IAM_role.html

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "ecs_events" {
  count = local.enabled_ecs_events

  name               = local.ecs_events_iam_name
  assume_role_policy = data.aws_iam_policy_document.ecs_events_assume_role_policy.json
  path               = var.iam_path
  description        = var.description
  tags               = merge({ "Name" = local.ecs_events_iam_name }, var.tags)
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
  count = local.enabled_ecs_events

  name        = local.ecs_events_iam_name
  policy      = data.aws_iam_policy.ecs_events.policy
  path        = var.iam_path
  description = var.description
}

data "aws_iam_policy" "ecs_events" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "ecs_events" {
  count = local.enabled_ecs_events

  role       = aws_iam_role.ecs_events[0].name
  policy_arn = aws_iam_policy.ecs_events[0].arn
}

locals {
  ecs_events_iam_name = "${var.name}-ecs-events"
  enabled_ecs_events  = var.enabled && var.create_ecs_events_role ? 1 : 0
}

# ECS Task Definitions
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html

# https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html
resource "aws_ecs_task_definition" "default" {
  count = var.enabled ? 1 : 0

  # A unique name for your task definition.
  family = var.name

  # The ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn = var.create_ecs_task_execution_role ? join("", aws_iam_role.ecs_task_execution.*.arn) : var.ecs_task_execution_role_arn

  # A list of container definitions in JSON format that describe the different containers that make up your task.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definitions
  container_definitions = var.container_definitions

  # The number of CPU units used by the task.
  # It can be expressed as an integer using CPU units, for example 1024, or as a string using vCPUs, for example 1 vCPU or 1 vcpu.
  # String values are converted to an integer indicating the CPU units when the task definition is registered.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
  cpu = var.cpu

  # The amount of memory (in MiB) used by the task.
  # It can be expressed as an integer using MiB, for example 1024, or as a string using GB, for example 1GB or 1 GB.
  # String values are converted to an integer indicating the MiB when the task definition is registered.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
  memory = var.memory

  # The launch type that the task is using.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#requires_compatibilities
  requires_compatibilities = var.requires_compatibilities

  # Fargate infrastructure support the awsvpc network mode.
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#network_mode
  network_mode = "awsvpc"

  # A mapping of tags to assign to the resource.
  tags = merge({ "Name" = var.name }, var.tags)
}

# ECS Task Execution IAM Role
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "ecs_task_execution" {
  count = local.enabled_ecs_task_execution

  name               = local.ecs_task_execution_iam_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json
  path               = var.iam_path
  description        = var.description
  tags               = merge({ "Name" = local.ecs_task_execution_iam_name }, var.tags)
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
  count = local.enabled_ecs_task_execution

  name        = local.ecs_task_execution_iam_name
  policy      = data.aws_iam_policy.ecs_task_execution.policy
  path        = var.iam_path
  description = var.description
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  count = local.enabled_ecs_task_execution

  role       = aws_iam_role.ecs_task_execution[0].name
  policy_arn = aws_iam_policy.ecs_task_execution[0].arn
}

locals {
  ecs_task_execution_iam_name = "${var.name}-ecs-task-execution"
  enabled_ecs_task_execution  = var.enabled && var.create_ecs_task_execution_role ? 1 : 0
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
