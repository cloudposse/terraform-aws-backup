variable "kms_key_arn" {
  type        = string
  description = "The server-side encryption key that is used to protect your backups"
  default     = null
}

variable "rules" {
  type = list(object({
    name                     = string
    schedule                 = optional(string)
    enable_continuous_backup = optional(bool)
    start_window             = optional(number)
    completion_window        = optional(number)
    lifecycle = optional(object({
      cold_storage_after                        = optional(number)
      delete_after                              = optional(number)
      opt_in_to_archive_for_supported_resources = optional(bool)
    }))
    copy_action = optional(object({
      destination_vault_arn = optional(string)
      lifecycle = optional(object({
        cold_storage_after                        = optional(number)
        delete_after                              = optional(number)
        opt_in_to_archive_for_supported_resources = optional(bool)
      }))
    }))
  }))
  description = <<-EOT
   A list of rule objects used to define schedules in a backup plan. Follows the following structure:

    ```yaml
      rules:
        - name: "plan-daily"
          schedule: "cron(0 5 ? * * *)"
          start_window: 320 # 60 * 8             # minutes
          completion_window: 10080 # 60 * 24 * 7 # minutes
          delete_after: 35 # 7 * 5               # days
        - name: "plan-weekly"
          schedule: "cron(0 5 ? * SAT *)"
          start_window: 320 # 60 * 8              # minutes
          completion_window: 10080 # 60 * 24 * 7  # minutes
          delete_after: 90 # 30 * 3
    ```

    EOT
  default     = []
}

variable "advanced_backup_setting" {
  type = object({
    backup_options = string
    resource_type  = string
  })
  description = "An object that specifies backup options for each resource type"
  default     = null
}

variable "backup_resources" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan"
  default     = []
}

variable "not_resources" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to exclude from a backup plan"
  default     = []
}

variable "selection_tags" {
  type = list(object({
    type  = string
    key   = string
    value = string
  }))
  description = "An array of tag condition objects used to filter resources based on tags for assigning to a backup plan"
  default     = []
}

variable "selection_conditions" {
  type = object({
    string_equals = optional(list(object({
      key   = string
      value = string
    })), [])
    string_like = optional(list(object({
      key   = string
      value = string
    })), [])
    string_not_equals = optional(list(object({
      key   = string
      value = string
    })), [])
    string_not_like = optional(list(object({
      key   = string
      value = string
    })), [])
  })
  description = "An array of conditions used to specify a set of resources to assign to a backup plan"
  default     = {}
}

variable "plan_name_suffix" {
  type        = string
  description = "The string appended to the plan name"
  default     = null
}

variable "vault_name" {
  type        = string
  description = "Override target Vault Name"
  default     = null
}

variable "vault_enabled" {
  type        = bool
  description = "Should we create a new Vault"
  default     = true
}

variable "plan_enabled" {
  type        = bool
  description = "Should we create a new Plan"
  default     = true
}

variable "iam_role_enabled" {
  type        = bool
  description = "Should we create a new Iam Role and Policy Attachment"
  default     = true
}

variable "iam_role_name" {
  type        = string
  description = "Override target IAM Role Name"
  default     = null
}

variable "permissions_boundary" {
  type        = string
  default     = null
  description = "The permissions boundary to set on the role"
}

variable "backup_vault_lock_configuration" {
  type = object({
    changeable_for_days = optional(number)
    max_retention_days  = optional(number)
    min_retention_days  = optional(number)
  })
  description = <<-EOT
    The backup vault lock configuration, each vault can have one vault lock in place. This will enable Backup Vault Lock on an AWS Backup vault  it prevents the deletion of backup data for the specified retention period. During this time, the backup data remains immutable and cannot be deleted or modified."
    `changeable_for_days` - The number of days before the lock date. If omitted creates a vault lock in `governance` mode, otherwise it will create a vault lock in `compliance` mode.
  EOT
  default     = null
}
