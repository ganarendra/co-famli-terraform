<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.57.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.cloudwatch_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.docdb_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.ebs_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.ecr_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.msk_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.s3_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.secretsmanager_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.sns_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cloudwatch_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.docdb_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.ebs_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.ecr_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.msk_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.s3_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.secretsmanager_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.sns_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | Global resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_arn"></a> [cloudwatch\_arn](#output\_cloudwatch\_arn) | CloudWatch KMS key ARN |
| <a name="output_cloudwatch_id"></a> [cloudwatch\_id](#output\_cloudwatch\_id) | CloudWatch KMS ID |
| <a name="output_cloudwatch_key_id"></a> [cloudwatch\_key\_id](#output\_cloudwatch\_key\_id) | CloudWatch KMS key id |
| <a name="output_docdb_arn"></a> [docdb\_arn](#output\_docdb\_arn) | DocDB KMS key ARN |
| <a name="output_docdb_id"></a> [docdb\_id](#output\_docdb\_id) | DocDB KMS ID |
| <a name="output_docdb_key_id"></a> [docdb\_key\_id](#output\_docdb\_key\_id) | DocDB KMS key id |
| <a name="output_ebs_id"></a> [ebs\_id](#output\_ebs\_id) | EBS KMS ID |
| <a name="output_ebs_key_id"></a> [ebs\_key\_id](#output\_ebs\_key\_id) | EBS KMS key id |
| <a name="output_ecr_arn"></a> [ecr\_arn](#output\_ecr\_arn) | ECR KMS key ARN |
| <a name="output_ecr_id"></a> [ecr\_id](#output\_ecr\_id) | ECR KMS ID |
| <a name="output_ecr_key_id"></a> [ecr\_key\_id](#output\_ecr\_key\_id) | ECR KMS key id |
| <a name="output_firehose_id"></a> [firehose\_id](#output\_firehose\_id) | Firehose KMS ID |
| <a name="output_firehose_key_arn"></a> [firehose\_key\_arn](#output\_firehose\_key\_arn) | Firehose KMS ARN |
| <a name="output_firehose_key_id"></a> [firehose\_key\_id](#output\_firehose\_key\_id) | Firehose KMS key id |
| <a name="output_msk_id"></a> [msk\_id](#output\_msk\_id) | MSK KMS ID |
| <a name="output_msk_key_id"></a> [msk\_key\_id](#output\_msk\_key\_id) | MSK KMS key id |
| <a name="output_s3_arn"></a> [s3\_arn](#output\_s3\_arn) | S3 KMS key ARN |
| <a name="output_s3_id"></a> [s3\_id](#output\_s3\_id) | S3 KMS ID |
| <a name="output_s3_key_id"></a> [s3\_key\_id](#output\_s3\_key\_id) | S3 KMS key id |
| <a name="output_secretsmanager_arn"></a> [secretsmanager\_arn](#output\_secretsmanager\_arn) | SecretsManager KMS key ARN |
| <a name="output_secretsmanager_id"></a> [secretsmanager\_id](#output\_secretsmanager\_id) | SecretsManager KMS ID |
| <a name="output_secretsmanager_key_id"></a> [secretsmanager\_key\_id](#output\_secretsmanager\_key\_id) | SecretsManager KMS key id |
| <a name="output_sns_id"></a> [sns\_id](#output\_sns\_id) | SNS KMS ID |
| <a name="output_sns_key_id"></a> [sns\_key\_id](#output\_sns\_key\_id) | SNS KMS key id |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
