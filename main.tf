# Terraform module which creates ECS Scheduled Task resources on AWS.
#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/scheduled_tasks.html

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
