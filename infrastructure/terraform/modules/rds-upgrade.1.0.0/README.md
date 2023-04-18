# TF code base
## Introduction
This is sample readme for terraform module

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.55.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_event_subscription.rds_microservices_db_backup_event_subscription](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/db_event_subscription) | resource |
| [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/db_parameter_group) | resource |
| [aws_db_proxy.famli_rds_proxy](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/db_proxy) | resource |
| [aws_db_proxy_default_target_group.famli_rds_proxy_target_group](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/db_proxy_default_target_group) | resource |
| [aws_db_proxy_target.famli_rds_proxy_db_target](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/db_proxy_target) | resource |
| [aws_db_subnet_group.famli_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/db_subnet_group) | resource |
| [aws_iam_policy.rds_proxy_policy](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.rds_backup_export_iam_role](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/iam_role) | resource |
| [aws_iam_role.rds_proxy_iam_role](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.rds-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.rds_backup_kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/kms_alias) | resource |
| [aws_kms_grant.a](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/kms_grant) | resource |
| [aws_kms_key.rds_backup_kms_key](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/kms_key) | resource |
| [aws_route53_record.db_proxy_route53_record_entry](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.famli-rds-secret](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.famli-rds-secret-reader](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.rds_secret_policy](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_policy.rds_secret_reader_policy](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_version.famli_rds_secret_version](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.famli_rds_secret_version_reader](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.rds_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/resources/security_group) | resource |
| [random_password.rds_password](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.rds_secret_name_suffix](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_string.random_suffix](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/string) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rds_secret_policy](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.control_tower_infraadmin_iam_role_arn](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/iam_role) | data source |
| [aws_kms_key.rds](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/kms_key) | data source |
| [aws_kms_key.sm](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/kms_key) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/region) | data source |
| [aws_subnet.app_subnets](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/subnet) | data source |
| [aws_subnet.database_subnets](https://registry.terraform.io/providers/hashicorp/aws/4.55.0/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_subnet_ids"></a> [app\_subnet\_ids](#input\_app\_subnet\_ids) | n/a | `list(any)` | n/a | yes |
| <a name="input_application_root_domain"></a> [application\_root\_domain](#input\_application\_root\_domain) | n/a | `string` | n/a | yes |
| <a name="input_control_tower_sso_infra_iam_role"></a> [control\_tower\_sso\_infra\_iam\_role](#input\_control\_tower\_sso\_infra\_iam\_role) | n/a | `string` | n/a | yes |
| <a name="input_database_subnet_ids"></a> [database\_subnet\_ids](#input\_database\_subnet\_ids) | n/a | `list(any)` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | n/a | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | n/a | `string` | n/a | yes |
| <a name="input_rds_snapshot_backup_sns_trigger"></a> [rds\_snapshot\_backup\_sns\_trigger](#input\_rds\_snapshot\_backup\_sns\_trigger) | n/a | `string` | n/a | yes |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | n/a | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Global resource tags | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `string` | n/a | yes |
| <a name="input_workstation_subnets"></a> [workstation\_subnets](#input\_workstation\_subnets) | n/a | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_credentials_secret_arn"></a> [rds\_credentials\_secret\_arn](#output\_rds\_credentials\_secret\_arn) | n/a |
| <a name="output_rds_credentials_secret_name"></a> [rds\_credentials\_secret\_name](#output\_rds\_credentials\_secret\_name) | n/a |
| <a name="output_rds_host_name"></a> [rds\_host\_name](#output\_rds\_host\_name) | n/a |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->

## Footer
