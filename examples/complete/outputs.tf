output "public_subnet_cidrs" {
  value = module.subnets.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = module.subnets.private_subnet_cidrs
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "efs_arn" {
  value       = module.efs.arn
  description = "EFS ARN"
}

output "efs_id" {
  value       = module.efs.id
  description = "EFS ID"
}

output "efs_host" {
  value       = module.efs.host
  description = "Route53 DNS hostname for the EFS"
}

output "efs_dns_name" {
  value       = module.efs.dns_name
  description = "EFS DNS name"
}

output "efs_mount_target_dns_names" {
  value       = module.efs.mount_target_dns_names
  description = "List of EFS mount target DNS names"
}

output "efs_mount_target_ids" {
  value       = module.efs.mount_target_ids
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "efs_mount_target_ips" {
  value       = module.efs.mount_target_ips
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "efs_network_interface_ids" {
  value       = module.efs.network_interface_ids
  description = "List of mount target network interface IDs"
}

output "backup_vault_id" {
  value       = module.backup.backup_vault_id
  description = "Backup Vault ID"
}

output "backup_vault_arn" {
  value       = module.backup.backup_vault_arn
  description = "Backup Vault ARN"
}

output "backup_plan_arn" {
  value       = module.backup.backup_plan_arn
  description = "Backup Plan ARN"
}

output "backup_plan_version" {
  value       = module.backup.backup_plan_version
  description = "Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan"
}

output "backup_selection_id" {
  value       = module.backup.backup_selection_id
  description = "Backup Selection ID"
}
