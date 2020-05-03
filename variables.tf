variable "name" {
  type        = string
  description = "The name of ecs task definition."
}

variable "schedule_expression" {
  type        = string
  description = "The scheduling expression.For example, `cron(0 20 * * ? *)` or `rate(5 minutes)`."
}

variable "cluster_arn" {
  type        = string
  description = "ARN of an ECS cluster."
}

variable "subnets" {
  type        = list(string)
  description = "The subnets associated with the task or service."
}

variable "container_definitions" {
  type        = string
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "is_enabled" {
  default     = true
  type        = string
  description = "Whether the rule should be enabled."
}

variable "task_count" {
  default     = 1
  type        = string
  description = "The number of tasks to create based on the TaskDefinition."
}

variable "platform_version" {
  default     = "1.4.0"
  type        = string
  description = "Specifies the platform version for the task."
}

variable "assign_public_ip" {
  default     = false
  type        = string
  description = "Assign a public IP address to the ENI (Fargate launch type only)."
}

variable "security_groups" {
  default     = []
  type        = list(string)
  description = "The security groups associated with the task or service."
}

variable "cpu" {
  default     = "256"
  type        = string
  description = "The number of cpu units used by the task."
}

variable "memory" {
  default     = "512"
  type        = string
  description = "The amount (in MiB) of memory used by the task."
}

variable "requires_compatibilities" {
  default     = ["FARGATE"]
  type        = list(string)
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
}

variable "iam_path" {
  default     = "/"
  type        = string
  description = "Path in which to create the IAM Role and the IAM Policy."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

variable "enabled" {
  default     = true
  type        = bool
  description = "Set to false to prevent the module from creating anything."
}

variable "create_ecs_events_role" {
  default     = true
  type        = string
  description = "Specify true to indicate that CloudWatch Events IAM Role creation."
}

variable "ecs_events_role_arn" {
  default     = ""
  type        = string
  description = "The ARN of the CloudWatch Events IAM Role."
}

variable "create_ecs_task_execution_role" {
  default     = true
  type        = string
  description = "Specify true to indicate that ECS Task Execution IAM Role creation."
}

variable "ecs_task_execution_role_arn" {
  default     = ""
  type        = string
  description = "The ARN of the ECS Task Execution IAM Role."
}
