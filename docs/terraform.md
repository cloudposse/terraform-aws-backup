## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| backup_resources | An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan | list(string) | - | yes |
| cold_storage_after | Specifies the number of days after creation that a recovery point is moved to cold storage | number | `null` | no |
| completion_window | The amount of time AWS Backup attempts a backup before canceling the job and returning an error. Must be at least 60 minutes greater than `start_window` | number | `null` | no |
| delete_after | Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after` | number | `null` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| kms_key_arn | The server-side encryption key that is used to protect your backups | string | `null` | no |
| name | Solution name, e.g. 'app' or 'cluster' | string | - | yes |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | `` | no |
| schedule | A CRON expression specifying when AWS Backup initiates a backup job | string | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | `` | no |
| start_window | The amount of time in minutes before beginning a backup. Minimum value is 60 minutes | number | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| backup_plan_arn | Backup Plan ARN |
| backup_plan_version | Unique, randomly generated, Unicode, UTF-8 encoded string that serves as the version ID of the backup plan |
| backup_selection_id | Backup Selection ID |
| backup_vault_arn | Backup Vault ARN |
| backup_vault_id | Backup Vault ID |
| backup_vault_recovery_points | Backup Vault recovery points |

