# TF code base
## Introduction
This is sample readme for terraform module

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agency_name"></a> [agency\_name](#input\_agency\_name) | the three or four letter acronym of the agency, e.g. cdhs, cdot, dnr | `string` | n/a | yes |
| <a name="input_backupdays"></a> [backupdays](#input\_backupdays) | Number of days that the resource is to be backed up | `string` | `"30"` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | the name of the environment, one of d, t, p, r, m, u | `string` | n/a | yes |
| <a name="input_fundingrequest_name"></a> [fundingrequest\_name](#input\_fundingrequest\_name) | the funding request number | `string` | `"notset"` | no |
| <a name="input_po_name"></a> [po\_name](#input\_po\_name) | name of the po to charge against | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | the name of the project, e.g. fueltax, tableau, mycolorado | `string` | n/a | yes |
| <a name="input_sharedcostgroup_name"></a> [sharedcostgroup\_name](#input\_sharedcostgroup\_name) | if sharing costs, group name | `string` | `"na"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | n/a |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->

## Footer
