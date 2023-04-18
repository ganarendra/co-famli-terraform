#!/bin/bash
#
# This script adds a git submodule containing terraform modules which allows
# terraform to be run locally outside of a pipeline, useful for when testing
# small changes.
#
# Please read wiki article regarding usage
# https://dev.azure.com/SOC-OIT/Infrastructure/_wiki/wikis/Infrastructure.wiki/3472/Use-Git-Submodules-for-Local-Terraform-Testing
#
echo "adding terraform module repository to infrastructure/terraform/modules/external..."
git submodule add --force https://dev.azure.com/SOC-OIT/Infrastructure/_git/cloudteam-terraform-pipeline-modules ../infrastructure/terraform/modules/external
echo "done."
