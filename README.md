# CDLE FAMLI Benefits IaC
Terraform project to manage all AWS resources for the CDLE FAMLI Benefits environments.

# Prerequisites

## Terraform
This project is built upon [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) infrastructure-as-code (IaC). Using IaC allows the ability to track
environment changes in code and provides traceability and accountability to infrastructure changes.
This project is built and tested against Terraform version `1.2.0` or later.

## Pre-Commit Hooks

This repository utilizes pre-commit git hooks to enfornce linting and documentation standards. Please intall the following utilities prior to committing your first change to the repository.

| Link                                                                  | Description                                                                             |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------
| [Pre-Commit](https://pre-commit.com/#installation)                    | `v3.0.4` A framework for managing and maintaining multi-language pre-commit hooks       |
| [Terraform Docs](https://terraform-docs.io/user-guide/installation/)  | `v0.16.0` Generate Terraform modules documentation                                      |
| [Terraform Lint](https://github.com/terraform-linters/tflint)         | `v0.45.0` A Pluggable Terraform Linter                                                  |


# Build and Test

## Pre-Commit Hooks
Install the git hook scripts
```bash
$ pre-commit install
```

(optional) Run against all the files
```bash
$ pre-commit run --all-files
```
(optional) Run a particular hook:
```bash
$ pre-commit run terraform-validate --all-files
```

## Documentation

Use `terraform-docs` to generate updated documentation of the modules.
```bash
$ terraform-docs infrastructure/terraform
```

## Format

This project uses standard Terraform formating to adhere to readability standards.
Use the following command to check and enforce your formating:
```bash
$ terraform -chdir=infrastructure/terraform/ fmt -recursive
```

## Validation
```bash
$ terraform -chdir=infrastructure/terraform/ validate
```

## Linting

Use `tflint` to find possible errors, warn about deprecated syntax, unused declarations, and enforce best practices, naming conventions.
```bash
$ tflint --init
$ tflint --recursive --disable-rule=terraform_required_providers --disable-rule=terraform_required_version
```
