variable "name" {
  type        = "string"
  description = "The name of ecs task definition."
}

variable "schedule_expression" {
  type        = "string"
  description = "The scheduling expression.For example, `cron(0 20 * * ? *)` or `rate(5 minutes)`."
}

variable "cluster_arn" {
  type        = "string"
  description = "ARN of an ECS cluster."
}

variable "subnets" {
  type        = "list"
  description = "The subnets associated with the task or service."
}

variable "container_definitions" {
  type        = "string"
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "is_enabled" {
  default     = true
  type        = "string"
  description = "Whether the rule should be enabled."
}

variable "task_count" {
  default     = 1
  type        = "string"
  description = "The number of tasks to create based on the TaskDefinition."
}

variable "platform_version" {
  default     = "LATEST"
  type        = "string"
  description = "Specifies the platform version for the task."
}

variable "assign_public_ip" {
  default     = false
  type        = "string"
  description = "Assign a public IP address to the ENI (Fargate launch type only)."
}

variable "security_groups" {
  default     = []
  type        = "list"
  description = "The security groups associated with the task or service."
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

variable "ecs_task_execution_policy" {
  default     = ""
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

variable "enabled" {
  default     = true
  type        = "string"
  description = "Set to false to prevent the module from creating anything."
}
