variable "name" {
  type        = "string"
  description = "The name of ecs task definition."
}

variable "ecs_task_execution_policy" {
  type        = "string"
  description = "The ecs task execution policy document. This is a JSON formatted string."
}

variable "iam_path" {
  default     = "/"
  type        = "string"
  description = "Path in which to create the IAM Role and the IAM Policy."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = "string"
  description = "The description of the all resources."
}

variable "tags" {
  default     = {}
  type        = "map"
  description = "A mapping of tags to assign to all resources."
}
