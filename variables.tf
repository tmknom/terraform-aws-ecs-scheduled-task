variable "name" {
  type        = "string"
  description = "The name of ecs task definition."
}

variable "ecs_task_execution_policy" {
  type        = "string"
  description = "The ecs task execution policy document. This is a JSON formatted string."
}

variable "container_definitions" {
  type        = "string"
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "cpu" {
  default     = "256"
  type        = "string"
  description = "The number of cpu units used by the task."
}

variable "memory" {
  default     = "512"
  type        = "string"
  description = "The amount (in MiB) of memory used by the task."
}

variable "requires_compatibilities" {
  default     = ["FARGATE"]
  type        = "list"
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
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
