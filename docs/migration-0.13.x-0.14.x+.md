# Migration from 0.13.x to 0.14.x

Version 0.14.0 of this module implements ability to add multiple schedules in a backup plan. This requires changing inputs to the module slightly. Make sure to update your configuration to use the new syntax.

Before:

```hcl
module "backup" {
  source = "cloudposse/backup/aws"

  schedule           = var.schedule
  start_window       = var.start_window
  completion_window  = var.completion_window
  cold_storage_after = var.cold_storage_after
  delete_after       = var.delete_after
}
```

After:

```hcl
module "backup" {
  source = "cloudposse/backup/aws"

  rules = [
    {
      schedule           = var.schedule
      start_window       = var.start_window
      completion_window  = var.completion_window
      lifecycle = {
        cold_storage_after = var.cold_storage_after
        delete_after       = var.delete_after
      }
    }
  ]
}
```

Now you can have multiple backup schedules:

```hcl
module "backup" {
  source = "cloudposse/backup/aws"

  rules = [
    {
      name               = "daily"
      schedule           = "cron(0 10 * * ? *)"
      start_window       = 60
      completion_window  = 120
      lifecycle = {
        cold_storage_after = 30
        delete_after       = 180
      }
    },
    {
      name               = "monthly"
      schedule           = "cron(0 12 1 * ? *)"
      start_window       = 60
      completion_window  = 120
      lifecycle = {
        cold_storage_after = 30
        delete_after       = 180
      }
    }
  ]
}
```
