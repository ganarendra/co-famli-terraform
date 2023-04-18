terraform {
  required_version = ">= 1.2.0"

  backend "s3" {
    encrypt        = true
    bucket         = "oit-infra-p-terraform"
    key            = "cdle/cdle-famli-staging.tfstate"
    region         = "us-east-1"
    dynamodb_table = "oit-infra-tf-state-lock-dynamo-p"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.3.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      # Tagging Standard reference: https://dev.azure.com/SOC-OIT/Infrastructure/_wiki/wikis/Infrastructure.wiki/180/Tag-values-for-environments
      environment    = var.environment
      agency         = var.agency
      project        = var.project
      dataclass      = var.dataclass
      po             = var.po
      fundingrequest = var.fundingrequest
      division       = var.division
    }
  }
}

provider "random" {
  # Configuration options
}

provider "archive" {
  # Configuration options
}
