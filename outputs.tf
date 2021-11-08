output "backup_vault_id" {
  value       = local.vault_id
  description = "Backup Vault ID"
}

output "backup_vault_arn" {
  value       = local.vault_arn
  description = "Backup Vault ARN"
}

output "backup_plan_arn" {
  value       = join("", aws_backup_plan.default.*.arn)
  description = "Backup Plan ARN"
}

output "backup_plan_version" {
  value       = join("", aws_backup_plan.default.*.version)
  description = "Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan"
}

output "backup_selection_id" {
  value       = join("", aws_backup_selection.default.*.id)
  description = "Backup Selection ID"
}
