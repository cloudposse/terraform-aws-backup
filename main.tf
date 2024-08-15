locals {
  enabled                = module.this.enabled
  plan_enabled           = local.enabled && var.plan_enabled
  iam_role_enabled       = local.enabled && var.iam_role_enabled
  iam_role_name          = local.enabled ? coalesce(var.iam_role_name, module.label_backup_role.id) : null
  iam_role_arn           = join("", var.iam_role_enabled ? aws_iam_role.default[*].arn : data.aws_iam_role.existing[*].arn)
  iam_role_serivce_roles = ["AWSBackupServiceRolePolicyForBackup", "AWSBackupServiceRolePolicyForS3Backup"]
  vault_enabled          = local.enabled && var.vault_enabled
  vault_name             = local.enabled ? coalesce(var.vault_name, module.this.id) : null
  vault_id               = join("", local.vault_enabled ? aws_backup_vault.default[*].id : data.aws_backup_vault.existing[*].id)
  vault_arn              = join("", local.vault_enabled ? aws_backup_vault.default[*].arn : data.aws_backup_vault.existing[*].arn)
}

data "aws_partition" "current" {}

module "label_backup_role" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  enabled    = local.enabled
  attributes = ["backup"]

  context = module.this.context
}

resource "aws_backup_vault" "default" {
  count       = local.vault_enabled ? 1 : 0
  name        = local.vault_name
  kms_key_arn = var.kms_key_arn
  tags        = module.this.tags
}

resource "aws_backup_vault_lock_configuration" "default" {
  count               = local.vault_enabled && var.backup_vault_lock_configuration != null ? 1 : 0
  backup_vault_name   = aws_backup_vault.default[0].id
  changeable_for_days = var.backup_vault_lock_configuration.changeable_for_days
  max_retention_days  = var.backup_vault_lock_configuration.max_retention_days
  min_retention_days  = var.backup_vault_lock_configuration.min_retention_days
}

data "aws_backup_vault" "existing" {
  count = local.enabled && var.vault_enabled == false ? 1 : 0
  name  = local.vault_name
}

resource "aws_backup_plan" "default" {
  count = local.plan_enabled ? 1 : 0
  name  = var.plan_name_suffix == null ? module.this.id : format("%s_%s", module.this.id, var.plan_name_suffix)

  dynamic "rule" {
    for_each = var.rules

    content {
      rule_name                = lookup(rule.value, "name", "${module.this.id}-${rule.key}")
      target_vault_name        = join("", local.vault_enabled ? aws_backup_vault.default[*].name : data.aws_backup_vault.existing[*].name)
      schedule                 = rule.value.schedule
      start_window             = rule.value.start_window
      completion_window        = rule.value.completion_window
      recovery_point_tags      = module.this.tags
      enable_continuous_backup = rule.value.enable_continuous_backup

      dynamic "lifecycle" {
        for_each = lookup(rule.value, "lifecycle", null) != null ? [true] : []

        content {
          cold_storage_after = rule.value.lifecycle.cold_storage_after
          delete_after       = rule.value.lifecycle.delete_after
        }
      }

      dynamic "copy_action" {
        for_each = try(lookup(rule.value.copy_action, "destination_vault_arn", null), null) != null ? [true] : []

        content {
          destination_vault_arn = rule.value.copy_action.destination_vault_arn

          dynamic "lifecycle" {
            for_each = lookup(rule.value.copy_action, "lifecycle", null) != null ? [true] : []

            content {
              cold_storage_after = rule.value.copy_action.lifecycle.cold_storage_after
              delete_after       = rule.value.copy_action.lifecycle.delete_after
            }
          }
        }
      }
    }
  }

  dynamic "advanced_backup_setting" {
    for_each = var.advanced_backup_setting != null ? [true] : []

    content {
      backup_options = var.advanced_backup_setting.backup_options
      resource_type  = var.advanced_backup_setting.resource_type
    }
  }

  tags = module.this.tags
}

data "aws_iam_policy_document" "assume_role" {
  count = local.iam_role_enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  count                = local.iam_role_enabled ? 1 : 0
  name                 = local.iam_role_name
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role[*].json)
  tags                 = module.label_backup_role.tags
  permissions_boundary = var.permissions_boundary
}

data "aws_iam_role" "existing" {
  count = local.enabled && var.iam_role_enabled == false ? 1 : 0
  name  = local.iam_role_name
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each   = { for role in local.iam_role_serivce_roles : role => role if local.iam_role_enabled }
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/${each.value}"
  role       = join("", aws_iam_role.default[*].name)
}

resource "aws_backup_selection" "default" {
  count         = local.plan_enabled ? 1 : 0
  name          = module.this.id
  iam_role_arn  = local.iam_role_arn
  plan_id       = join("", aws_backup_plan.default[*].id)
  resources     = var.backup_resources
  not_resources = var.not_resources
  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
      value = selection_tag.value["value"]
    }
  }
}
