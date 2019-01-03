# terraform-aws-ecs-scheduled-task

[![CircleCI](https://circleci.com/gh/tmknom/terraform-aws-ecs-scheduled-task.svg?style=svg)](https://circleci.com/gh/tmknom/terraform-aws-ecs-scheduled-task)
[![GitHub tag](https://img.shields.io/github/tag/tmknom/terraform-aws-ecs-scheduled-task.svg)](https://registry.terraform.io/modules/tmknom/ecs-scheduled-task/aws)
[![License](https://img.shields.io/github/license/tmknom/terraform-aws-ecs-scheduled-task.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module which creates ECS Scheduled Task resources on AWS.

## Description

Provision [ECS Task Definitions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html) and
[CloudWatch Events](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/WhatIsCloudWatchEvents.html).

This module provides recommended settings:

- Fargate launch type
- Disable assign public ip address

## Usage

### Minimal

```hcl
module "ecs_scheduled_task" {
  source                = "git::https://github.com/tmknom/terraform-aws-ecs-scheduled-task.git?ref=tags/1.0.0"
  name                  = "example"
  schedule_expression   = "rate(3 minutes)"
  container_definitions = "${var.container_definitions}"
  cluster_arn           = "${var.cluster_arn}"
  subnets               = ["${var.subnets}"]
}
```

### Complete

```hcl
module "ecs_scheduled_task" {
  source                = "git::https://github.com/tmknom/terraform-aws-ecs-scheduled-task.git?ref=tags/1.0.0"
  name                  = "example"
  schedule_expression   = "rate(3 minutes)"
  container_definitions = "${var.container_definitions}"
  cluster_arn           = "${var.cluster_arn}"
  subnets               = ["${var.subnets}"]

  ecs_task_execution_policy = "${var.ecs_task_execution_policy}"
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

  tags = {
    Environment = "prod"
  }
}
```

## Examples

- [Minimal](https://github.com/tmknom/terraform-aws-ecs-scheduled-task/tree/master/examples/minimal)
- [Complete](https://github.com/tmknom/terraform-aws-ecs-scheduled-task/tree/master/examples/complete)

## Inputs

| Name                      | Description                                                                       |  Type  |        Default         | Required |
| ------------------------- | --------------------------------------------------------------------------------- | :----: | :--------------------: | :------: |
| cluster_arn               | ARN of an ECS cluster.                                                            | string |           -            |   yes    |
| container_definitions     | A list of valid container definitions provided as a single valid JSON document.   | string |           -            |   yes    |
| name                      | The name of ecs task definition.                                                  | string |           -            |   yes    |
| schedule_expression       | The scheduling expression.For example, `cron(0 20 * * ? *)` or `rate(5 minutes)`. | string |           -            |   yes    |
| subnets                   | The subnets associated with the task or service.                                  |  list  |           -            |   yes    |
| assign_public_ip          | Assign a public IP address to the ENI (Fargate launch type only).                 | string |        `false`         |    no    |
| cpu                       | The number of cpu units used by the task.                                         | string |         `256`          |    no    |
| description               | The description of the all resources.                                             | string | `Managed by Terraform` |    no    |
| ecs_task_execution_policy | The ecs task execution policy document. This is a JSON formatted string.          | string |        `` | no         |
| iam_path                  | Path in which to create the IAM Role and the IAM Policy.                          | string |          `/`           |    no    |
| is_enabled                | Whether the rule should be enabled.                                               | string |         `true`         |    no    |
| memory                    | The amount (in MiB) of memory used by the task.                                   | string |         `512`          |    no    |
| platform_version          | Specifies the platform version for the task.                                      | string |        `LATEST`        |    no    |
| requires_compatibilities  | A set of launch types required by the task. The valid values are EC2 and FARGATE. |  list  |    `[ "FARGATE" ]`     |    no    |
| security_groups           | The security groups associated with the task or service.                          |  list  |          `[]`          |    no    |
| tags                      | A mapping of tags to assign to all resources.                                     |  map   |          `{}`          |    no    |
| task_count                | The number of tasks to create based on the TaskDefinition.                        | string |          `1`           |    no    |

## Outputs

| Name                                  | Description                                                                |
| ------------------------------------- | -------------------------------------------------------------------------- |
| cloudwatch_event_rule_arn             | The Amazon Resource Name (ARN) of the rule.                                |
| ecs_events_policy_arn                 | The ARN assigned by AWS to this CloudWatch Events IAM Policy.              |
| ecs_events_policy_description         | The description of the CloudWatch Events IAM Policy.                       |
| ecs_events_policy_document            | The policy document of the CloudWatch Events IAM Policy.                   |
| ecs_events_policy_id                  | The CloudWatch Events IAM Policy's ID.                                     |
| ecs_events_policy_name                | The name of the CloudWatch Events IAM Policy.                              |
| ecs_events_policy_path                | The path of the CloudWatch Events IAM Policy.                              |
| ecs_events_role_arn                   | The Amazon Resource Name (ARN) specifying the CloudWatch Events IAM Role.  |
| ecs_events_role_create_date           | The creation date of the IAM Role.                                         |
| ecs_events_role_description           | The description of the CloudWatch Events IAM Role.                         |
| ecs_events_role_name                  | The name of the CloudWatch Events IAM Role.                                |
| ecs_events_role_unique_id             | The stable and unique string identifying the CloudWatch Events IAM Role.   |
| ecs_task_definition_arn               | Full ARN of the Task Definition (including both family and revision).      |
| ecs_task_definition_family            | The family of the Task Definition.                                         |
| ecs_task_definition_revision          | The revision of the task in a particular family.                           |
| ecs_task_execution_policy_arn         | The ARN assigned by AWS to this ECS Task Execution IAM Policy.             |
| ecs_task_execution_policy_description | The description of the ECS Task Execution IAM Policy.                      |
| ecs_task_execution_policy_document    | The policy document of the ECS Task Execution IAM Policy.                  |
| ecs_task_execution_policy_id          | The ECS Task Execution IAM Policy's ID.                                    |
| ecs_task_execution_policy_name        | The name of the ECS Task Execution IAM Policy.                             |
| ecs_task_execution_policy_path        | The path of the ECS Task Execution IAM Policy.                             |
| ecs_task_execution_role_arn           | The Amazon Resource Name (ARN) specifying the ECS Task Execution IAM Role. |
| ecs_task_execution_role_create_date   | The creation date of the ECS Task Execution IAM Role.                      |
| ecs_task_execution_role_description   | The description of the ECS Task Execution IAM Role.                        |
| ecs_task_execution_role_name          | The name of the ECS Task Execution IAM Role.                               |
| ecs_task_execution_role_unique_id     | The stable and unique string identifying the ECS Task Execution IAM Role.  |

## Development

### Requirements

- [Docker](https://www.docker.com/)

### Configure environment variables

```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=ap-northeast-1
```

### Installation

```shell
git clone git@github.com:tmknom/terraform-aws-ecs-scheduled-task.git
cd terraform-aws-ecs-scheduled-task
make install
```

### Makefile targets

```text
check-format                   Check format code
cibuild                        Execute CI build
clean                          Clean .terraform
docs                           Generate docs
format                         Format code
help                           Show help
install                        Install requirements
lint                           Lint code
release                        Release GitHub and Terraform Module Registry
terraform-apply-complete       Run terraform apply examples/complete
terraform-apply-minimal        Run terraform apply examples/minimal
terraform-destroy-complete     Run terraform destroy examples/complete
terraform-destroy-minimal      Run terraform destroy examples/minimal
terraform-plan-complete        Run terraform plan examples/complete
terraform-plan-minimal         Run terraform plan examples/minimal
upgrade                        Upgrade makefile
```

### Releasing new versions

Bump VERSION file, and run `make release`.

### Terraform Module Registry

- <https://registry.terraform.io/modules/tmknom/ecs-scheduled-task/aws>

## License

Apache 2 Licensed. See LICENSE for full details.
