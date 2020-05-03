output "cloudwatch_event_rule_arn" {
  value       = join("", aws_cloudwatch_event_rule.default.*.arn)
  description = "The Amazon Resource Name (ARN) of the rule."
}

output "ecs_events_role_arn" {
  value       = join("", aws_iam_role.ecs_events.*.arn)
  description = "The Amazon Resource Name (ARN) specifying the CloudWatch Events IAM Role."
}

output "ecs_events_role_create_date" {
  value       = join("", aws_iam_role.ecs_events.*.create_date)
  description = "The creation date of the IAM Role."
}

output "ecs_events_role_unique_id" {
  value       = join("", aws_iam_role.ecs_events.*.unique_id)
  description = "The stable and unique string identifying the CloudWatch Events IAM Role."
}

output "ecs_events_role_name" {
  value       = join("", aws_iam_role.ecs_events.*.name)
  description = "The name of the CloudWatch Events IAM Role."
}

output "ecs_events_role_description" {
  value       = join("", aws_iam_role.ecs_events.*.description)
  description = "The description of the CloudWatch Events IAM Role."
}

output "ecs_events_policy_id" {
  value       = join("", aws_iam_policy.ecs_events.*.id)
  description = "The CloudWatch Events IAM Policy's ID."
}

output "ecs_events_policy_arn" {
  value       = join("", aws_iam_policy.ecs_events.*.arn)
  description = "The ARN assigned by AWS to this CloudWatch Events IAM Policy."
}

output "ecs_events_policy_description" {
  value       = join("", aws_iam_policy.ecs_events.*.description)
  description = "The description of the CloudWatch Events IAM Policy."
}

output "ecs_events_policy_name" {
  value       = join("", aws_iam_policy.ecs_events.*.name)
  description = "The name of the CloudWatch Events IAM Policy."
}

output "ecs_events_policy_path" {
  value       = join("", aws_iam_policy.ecs_events.*.path)
  description = "The path of the CloudWatch Events IAM Policy."
}

output "ecs_events_policy_document" {
  value       = join("", aws_iam_policy.ecs_events.*.policy)
  description = "The policy document of the CloudWatch Events IAM Policy."
}

output "ecs_task_definition_arn" {
  value       = join("", aws_ecs_task_definition.default.*.arn)
  description = "Full ARN of the Task Definition (including both family and revision)."
}

output "ecs_task_definition_family" {
  value       = join("", aws_ecs_task_definition.default.*.family)
  description = "The family of the Task Definition."
}

output "ecs_task_definition_revision" {
  value       = join("", aws_ecs_task_definition.default.*.revision)
  description = "The revision of the task in a particular family."
}

output "ecs_task_execution_role_arn" {
  value       = join("", aws_iam_role.ecs_task_execution.*.arn)
  description = "The Amazon Resource Name (ARN) specifying the ECS Task Execution IAM Role."
}

output "ecs_task_execution_role_create_date" {
  value       = join("", aws_iam_role.ecs_task_execution.*.create_date)
  description = "The creation date of the ECS Task Execution IAM Role."
}

output "ecs_task_execution_role_unique_id" {
  value       = join("", aws_iam_role.ecs_task_execution.*.unique_id)
  description = "The stable and unique string identifying the ECS Task Execution IAM Role."
}

output "ecs_task_execution_role_name" {
  value       = join("", aws_iam_role.ecs_task_execution.*.name)
  description = "The name of the ECS Task Execution IAM Role."
}

output "ecs_task_execution_role_description" {
  value       = join("", aws_iam_role.ecs_task_execution.*.description)
  description = "The description of the ECS Task Execution IAM Role."
}

output "ecs_task_execution_policy_id" {
  value       = join("", aws_iam_policy.ecs_task_execution.*.id)
  description = "The ECS Task Execution IAM Policy's ID."
}

output "ecs_task_execution_policy_arn" {
  value       = join("", aws_iam_policy.ecs_task_execution.*.arn)
  description = "The ARN assigned by AWS to this ECS Task Execution IAM Policy."
}

output "ecs_task_execution_policy_description" {
  value       = join("", aws_iam_policy.ecs_task_execution.*.description)
  description = "The description of the ECS Task Execution IAM Policy."
}

output "ecs_task_execution_policy_name" {
  value       = join("", aws_iam_policy.ecs_task_execution.*.name)
  description = "The name of the ECS Task Execution IAM Policy."
}

output "ecs_task_execution_policy_path" {
  value       = join("", aws_iam_policy.ecs_task_execution.*.path)
  description = "The path of the ECS Task Execution IAM Policy."
}

output "ecs_task_execution_policy_document" {
  value       = join("", aws_iam_policy.ecs_task_execution.*.policy)
  description = "The policy document of the ECS Task Execution IAM Policy."
}
