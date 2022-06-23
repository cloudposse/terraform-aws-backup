variable "schedule" {
  type        = string
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    A CRON expression specifying when AWS Backup initiates a backup job
    EOT
  default     = null
}

variable "start_window" {
  type        = number
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    The amount of time in minutes before beginning a backup. Minimum value is 60 minutes
    EOT
  default     = null
}

variable "completion_window" {
  type        = number
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than `start_window`
    EOT
  default     = null
}

variable "cold_storage_after" {
  type        = number
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    Specifies the number of days after creation that a recovery point is moved to cold storage
    EOT
  default     = null
}

variable "delete_after" {
  type        = number
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after`
    EOT
  default     = null
}

variable "destination_vault_arn" {
  type        = string
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    An Amazon Resource Name (ARN) that uniquely identifies the destination backup vault for the copied backup
    EOT
  default     = null
}

variable "copy_action_cold_storage_after" {
  type        = number
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    For copy operation, specifies the number of days after creation that a recovery point is moved to cold storage
    EOT
  default     = null
}

variable "copy_action_delete_after" {
  type        = number
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    For copy operation, specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `copy_action_cold_storage_after`
    EOT
  default     = null
}

variable "enable_continuous_backup" {
  type        = bool
  description = <<-EOT
    DEPRECATED: see [migration guide](./docs/migration-0.13.x-0.14.x+.md)
    Enable continuous backups for supported resources.
    EOT
  default     = null
}
