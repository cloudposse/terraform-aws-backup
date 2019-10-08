<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->
[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

# terraform-aws-backup [![Codefresh Build Status](https://g.codefresh.io/api/badges/pipeline/cloudposse/terraform-modules%2Fterraform-aws-backup?type=cf-1)](https://g.codefresh.io/public/accounts/cloudposse/pipelines/5d9c0dd46d867eabdb30d36e) [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-backup.svg)](https://github.com/cloudposse/terraform-aws-backup/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


Terraform module to provision [AWS Backup](https://aws.amazon.com/backup), a fully managed backup service that makes it easy to centralize and automate
the back up of data across AWS services such as EBS volumes, RDS databases, DynamoDB tables, EFS file systems, and AWS Storage Gateway volumes.


---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps. 
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out! 







## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=tags/x.y.z`) of one of our [latest releases](https://github.com/cloudposse/terraform-aws-backup/releases).



For a complete example on how to backup an Elastic File System (EFS), see [examples/complete]((examples/complete
)
```hcl
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
  source             = "git::https://github.com/cloudposse/terraform-aws-backup.git?ref=master"
  namespace          = var.namespace
  stage              = var.stage
  name               = var.name
  attributes         = var.attributes
  tags               = var.tags
  delimiter          = var.delimiter
  backup_resource    = [module.efs.arn]
  schedule           = var.schedule
  start_window       = var.start_window
  completion_window  = var.completion_window
  cold_storage_after = var.cold_storage_after
  delete_after       = var.delete_after
}
```






## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| backup_resource | An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan | list(string) | - | yes |
| cold_storage_after | Specifies the number of days after creation that a recovery point is moved to cold storage | number | `null` | no |
| completion_window | The amount of time AWS Backup attempts a backup before canceling the job and returning an error | number | `null` | no |
| delete_after | Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after` | number | `null` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| kms_key_arn | The server-side encryption key that is used to protect your backups | string | `null` | no |
| name | Solution name, e.g. 'app' or 'cluster' | string | - | yes |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | `` | no |
| schedule | A CRON expression specifying when AWS Backup initiates a backup job | string | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | `` | no |
| start_window | The amount of time in minutes before beginning a backup | number | `null` | no |
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




## Share the Love 

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-backup)! (it helps us **a lot**) 

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-efs](https://github.com/cloudposse/terraform-aws-efs) - Terraform module to provision EFS file system
- [terraform-aws-efs-backup](https://github.com/cloudposse/terraform-aws-efs-backup) - Terraform module to backup EFS filesystems to S3 using DataPipeline
- [terraform-aws-efs-cloudwatch-sns-alarms](https://github.com/cloudposse/terraform-aws-efs-cloudwatch-sns-alarms) - Terraform module that configures CloudWatch SNS alerts for EFS



## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-backup/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## Commercial Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide [*commercial support*][commercial_support] for all of our [Open Source][github] projects. As a *Dedicated Support* customer, you have access to our team of subject matter experts at a fraction of the cost of a full-time engineer. 

[![E-Mail](https://img.shields.io/badge/email-hello@cloudposse.com-blue.svg)][email]

- **Questions.** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting.** We'll help you triage why things aren't working.
- **Code Reviews.** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes.** We'll rapidly work to fix any bugs in our projects.
- **Build New Terraform Modules.** We'll [develop original modules][module_development] to provision infrastructure.
- **Cloud Architecture.** We'll assist with your cloud strategy and design.
- **Implementation.** We'll provide hands-on support to implement our reference architectures. 



## Terraform Module Development

Are you interested in custom Terraform module development? Submit your inquiry using [our form][module_development] today and we'll get back to you ASAP.


## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Newsletter

Signup for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover. 

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-backup/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2019 [Cloud Posse, LLC](https://cpco.io/copyright)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.  

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] |
|---|---|---|


  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144


  [aknysh_homepage]: https://github.com/aknysh/
  [aknysh_avatar]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144


  [goruha_homepage]: https://github.com/goruha/
  [goruha_avatar]: http://s.gravatar.com/avatar/bc70834d32ed4517568a1feb0b9be7e2?s=144




[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs
  [website]: https://cpco.io/homepage
  [github]: https://cpco.io/github
  [jobs]: https://cpco.io/jobs
  [hire]: https://cpco.io/hire
  [slack]: https://cpco.io/slack
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://cpco.io/twitter
  [testimonial]: https://cpco.io/leave-testimonial
  [newsletter]: https://cpco.io/newsletter
  [email]: https://cpco.io/email
  [commercial_support]: https://cpco.io/commercial-support
  [we_love_open_source]: https://cpco.io/we-love-open-source
  [module_development]: https://cpco.io/module-development
  [terraform_modules]: https://cpco.io/terraform-modules
  [readme_header_img]: https://cloudposse.com/readme/header/img?repo=cloudposse/terraform-aws-backup
  [readme_header_link]: https://cloudposse.com/readme/header/link?repo=cloudposse/terraform-aws-backup
  [readme_footer_img]: https://cloudposse.com/readme/footer/img?repo=cloudposse/terraform-aws-backup
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?repo=cloudposse/terraform-aws-backup
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img?repo=cloudposse/terraform-aws-backup
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?repo=cloudposse/terraform-aws-backup
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-backup&url=https://github.com/cloudposse/terraform-aws-backup
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-backup&url=https://github.com/cloudposse/terraform-aws-backup
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-backup
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-backup
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-backup
  [share_email]: mailto:?subject=terraform-aws-backup&body=https://github.com/cloudposse/terraform-aws-backup
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-backup?pixel&cs=github&cm=readme&an=terraform-aws-backup
