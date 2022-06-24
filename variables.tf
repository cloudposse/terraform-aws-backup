variable "kms_key_arn" {
  type        = string
  description = "The server-side encryption key that is used to protect your backups"
  default     = null
}

variable "rules" {
  type        = list(any)
  description = "An array of rule maps used to define schedules in a backup plan"
  default     = []
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

variable "advanced_backup_setting" {
  type        = any
  default     = null
  description = "An object that specifies backup options for each resource type."
}