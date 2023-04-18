terraform {
  required_version = ">= 1.2.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }
  }
}
