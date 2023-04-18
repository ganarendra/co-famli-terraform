#!/bin/bash
#
# This script removes a git submodule containing terraform modules which allows
# terraform to be run locally outside of a pipeline.
#
# Please read wiki article regarding usage
# https://dev.azure.com/SOC-OIT/Infrastructure/_wiki/wikis/Infrastructure.wiki/3472/Use-Git-Submodules-for-Local-Terraform-Testing
#
echo "removing terraform module repository to infrastructure/terraform/modules/external..."
git submodule deinit -f ../infrastructure/terraform/modules/external
git rm -f ../infrastructure/terraform/modules/external
git rm -f ../.gitmodules
echo "done."
