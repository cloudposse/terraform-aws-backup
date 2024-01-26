provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.1"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.1"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "efs" {
  source  = "cloudposse/efs/aws"
  version = "0.35.0"

  region          = var.region
  vpc_id          = module.vpc.vpc_id
  subnets         = module.subnets.private_subnet_ids
  security_groups = [module.vpc.vpc_default_security_group_id]

  context = module.this.context
}

module "backup" {
  source = "../.."

  backup_resources = [module.efs.arn]
  not_resources    = var.not_resources

  rules = [
    {
      name              = "${module.this.name}-daily"
      schedule          = var.schedule
      start_window      = var.start_window
      completion_window = var.completion_window
      lifecycle = {
        cold_storage_after = var.cold_storage_after
        delete_after       = var.delete_after
      }
    }
  ]

  backup_vault_lock_configuration = {
    max_retention_days = 365
    min_retention_days = 30
  }

  context = module.this.context
}

module "backup_deprecated" {
  source = "../.."

  attributes = ["deprecated"]

  backup_resources = [module.efs.arn]
  not_resources    = var.not_resources

  name               = "${module.this.name}-daily"
  schedule           = var.schedule
  start_window       = var.start_window
  completion_window  = var.completion_window
  cold_storage_after = var.cold_storage_after
  delete_after       = var.delete_after

  context = module.this.context
}
