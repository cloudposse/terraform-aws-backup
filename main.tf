module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  enabled    = var.enabled
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

module "label_backup_role" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  enabled    = var.enabled
  context    = module.label.context
  attributes = compact(concat(module.label.attributes, list("backup")))
}

resource "aws_backup_vault" "default" {
  count       = var.enabled ? 1 : 0
  name        = module.label.id
  kms_key_arn = var.kms_key_arn
  tags        = module.label.tags
}

resource "aws_backup_plan" "default" {
  count = var.enabled ? 1 : 0
  name  = module.label.id

  rule {
    rule_name           = module.label.id
    target_vault_name   = join("", aws_backup_vault.default.*.name)
    schedule            = var.schedule
    start_window        = var.start_window
    completion_window   = var.completion_window
    recovery_point_tags = module.label.tags

    dynamic "lifecycle" {
      for_each = var.cold_storage_after != null || var.delete_after != null ? ["true"] : []
      content {
        cold_storage_after = var.cold_storage_after
        delete_after       = var.delete_after
      }
    }
  }
}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0

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
  count              = var.enabled ? 1 : 0
  name               = module.label_backup_role.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  tags               = module.label_backup_role.tags
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_backup_selection" "default" {
  count        = var.enabled ? 1 : 0
  name         = module.label.id
  iam_role_arn = join("", aws_iam_role.default.*.arn)
  plan_id      = join("", aws_backup_plan.default.*.id)
  resources    = var.backup_resources
}
