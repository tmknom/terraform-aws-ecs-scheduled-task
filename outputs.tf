output "ecs_task_execution_role_arn" {
  value       = "${aws_iam_role.ecs_task_execution.arn}"
  description = "The Amazon Resource Name (ARN) specifying the ECS Task Execution IAM Role."
}

output "ecs_task_execution_role_create_date" {
  value       = "${aws_iam_role.ecs_task_execution.create_date}"
  description = "The creation date of the ECS Task Execution IAM Role."
}

output "ecs_task_execution_role_unique_id" {
  value       = "${aws_iam_role.ecs_task_execution.unique_id}"
  description = "The stable and unique string identifying the ECS Task Execution IAM Role."
}

output "ecs_task_execution_role_name" {
  value       = "${aws_iam_role.ecs_task_execution.name}"
  description = "The name of the ECS Task Execution IAM Role."
}

output "ecs_task_execution_role_description" {
  value       = "${aws_iam_role.ecs_task_execution.description}"
  description = "The description of the ECS Task Execution IAM Role."
}

output "ecs_task_execution_policy_id" {
  value       = "${aws_iam_policy.ecs_task_execution.id}"
  description = "The ECS Task Execution IAM Policy's ID."
}

output "ecs_task_execution_policy_arn" {
  value       = "${aws_iam_policy.ecs_task_execution.arn}"
  description = "The ARN assigned by AWS to this ECS Task Execution IAM Policy."
}

output "ecs_task_execution_policy_description" {
  value       = "${aws_iam_policy.ecs_task_execution.description}"
  description = "The description of the ECS Task Execution IAM Policy."
}

output "ecs_task_execution_policy_name" {
  value       = "${aws_iam_policy.ecs_task_execution.name}"
  description = "The name of the ECS Task Execution IAM Policy."
}

output "ecs_task_execution_policy_path" {
  value       = "${aws_iam_policy.ecs_task_execution.path}"
  description = "The path of the ECS Task Execution IAM Policy."
}

output "ecs_task_execution_policy_document" {
  value       = "${aws_iam_policy.ecs_task_execution.policy}"
  description = "The policy document of the ECS Task Execution IAM Policy."
}
