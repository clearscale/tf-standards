# Terraform Context

The Terraform context module is designed to provide a unified set of settings, configurations, and conventions that can be applied across all other modules. For instance, in the context of the AWS provider, it generates naming conventions and string templates in both dash and dot notations, which are useful when creating resources such as S3 buckets (using dash notation) and IAM roles or policies (using dot notation). Additionally, it offers a variety of string formats for the current AWS region, among other functionalities. This module should be integrated into your Terraform code to ensure consistent application of common standards.

## Usage

```terraform
module "context" {
  source    = "https://github.com/clearscale/tf-context.git"

  accounts = [
    { id = "*",            name = "dev",    provider = "aws", key = "current"},
    { id = "000000000000", name = "shared", provider = "aws", key = "shared"}
  ]

  prefix   = "ex"
  client   = "example"
  project  = "git"
  env      = "dev"
  region   = "us-east-1"
  name     = "codepipeline"
  function = "run"
  suffix   = "testingonly"
}
```