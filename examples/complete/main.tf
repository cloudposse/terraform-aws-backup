provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  tags       = var.tags
  delimiter  = var.delimiter
  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.0"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = var.attributes
  tags                 = var.tags
  delimiter            = var.delimiter
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
}

module "efs" {
  source             = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=tags/0.10.0"
  namespace          = var.namespace
  stage              = var.stage
  name               = var.name
  attributes         = var.attributes
  tags               = var.tags
  delimiter          = var.delimiter
  region             = var.region
  availability_zones = var.availability_zones
  vpc_id             = module.vpc.vpc_id
  subnets            = module.subnets.private_subnet_ids
  security_groups    = [module.vpc.vpc_default_security_group_id]
}

module "backup" {
  source             = "../.."
  namespace          = var.namespace
  stage              = var.stage
  name               = var.name
  attributes         = var.attributes
  tags               = var.tags
  delimiter          = var.delimiter
  backup_resources   = [module.efs.arn]
  schedule           = var.schedule
  start_window       = var.start_window
  completion_window  = var.completion_window
  cold_storage_after = var.cold_storage_after
  delete_after       = var.delete_after
}
