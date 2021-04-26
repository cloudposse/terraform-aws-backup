module "label_backup_role" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"
  enabled    = module.this.enabled
  attributes = ["backup"]

  context = module.this.context
}

resource "aws_backup_vault" "default" {
  count       = module.this.enabled ? 1 : 0
  name        = module.this.id
  kms_key_arn = var.kms_key_arn
  tags        = module.this.tags
}

resource "aws_backup_plan" "default" {
  count = module.this.enabled ? 1 : 0
  name  = module.this.id

  rule {
    rule_name           = module.this.id
    target_vault_name   = join("", aws_backup_vault.default.*.name)
    schedule            = var.schedule
    start_window        = var.start_window
    completion_window   = var.completion_window
    recovery_point_tags = module.this.tags

    dynamic "lifecycle" {
      for_each = var.cold_storage_after != null || var.delete_after != null ? ["true"] : []
      content {
        cold_storage_after = var.cold_storage_after
        delete_after       = var.delete_after
      }
    }

    dynamic "copy_action" {
      for_each = var.destination_vault_arn != null ? ["true"] : []
      content {
        destination_vault_arn = var.destination_vault_arn

        dynamic "lifecycle" {
          for_each = var.copy_action_cold_storage_after != null || var.copy_action_delete_after != null ? ["true"] : []
          content {
            cold_storage_after = var.copy_action_cold_storage_after
            delete_after       = var.copy_action_delete_after
          }
        }
      }
    }
  }

  tags = module.this.tags
}

data "aws_iam_policy_document" "assume_role" {
  count = module.this.enabled ? 1 : 0

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
  count              = module.this.enabled ? 1 : 0
  name               = module.label_backup_role.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  tags               = module.label_backup_role.tags
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = module.this.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_backup_selection" "default" {
  count        = module.this.enabled ? 1 : 0
  name         = module.this.id
  iam_role_arn = join("", aws_iam_role.default.*.arn)
  plan_id      = join("", aws_backup_plan.default.*.id)
  resources    = var.backup_resources
  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
      value = selection_tag.value["value"]
    }
  }
}
