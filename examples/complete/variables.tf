variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones"
}

variable "not_resources" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to exclude from a backup plan"
  default     = []
}

variable "schedule" {
  type        = string
  description = "A CRON expression specifying when AWS Backup initiates a backup job"
}

variable "start_window" {
  type        = number
  description = "The amount of time in minutes before beginning a backup. Minimum value is 60 minutes"
}

variable "completion_window" {
  type        = number
  description = "The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than `start_window`"
}

variable "cold_storage_after" {
  type        = number
  description = "Specifies the number of days after creation that a recovery point is moved to cold storage"
}

variable "delete_after" {
  type        = number
  description = "Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after`"
}
