#
# Set providers and versions.
# These values must be hardcoded. We can't use variables here.
# https://developer.hashicorp.com/terraform/language/providers/requirements
# https://registry.terraform.io/browse/providers
#
terraform {
  required_version = ">= 1.5.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#
# Current AWS context from the primary provider
#
data "aws_caller_identity" "current" {
  count = (length(var.id) < 12) ? 1 : 0
}

#
# Current AWS region
#
data "aws_region" "current" {}
