# Terraform Standards (STD)

The Terraform standards module is designed to provide a unified set of settings, configurations, and conventions that can be applied across all other modules. For instance, in the context of the AWS provider, it generates naming conventions and string templates in both dash and dot notations, which are useful when creating resources such as S3 buckets (using dash notation) and IAM roles or policies (using dot notation). Additionally, it offers a variety of string formats for the current AWS region, among other functionalities. This module should be integrated into your Terraform code to ensure consistent application of common standards.

## Usage

```terraform
module "std" {
  source =  "https://github.com/clearscale/tf-standards.git"

  accounts = [
    { id = "*", name = "dev",    provider = "aws", key = "current", region = "us-east-1"},
    { id = "*", name = "shared", provider = "aws", key = "shared"}
  ]

  prefix   = "cs"
  client   = "ClearScale"
  project  = "pmod"
  env      = "dev"        # Can be omitted. Defaults to "dev".
  region   = "us-west-1"  # Can be omitted. Defaults to us-west-1.
  name     = "standards"  # Can be omitted. Defaults to "Default".
  function = "test"       # Can be omitted. Will not be included in naming conventions if not specified.
  suffix   = "local"      # Can be omitted. Will not be included in naming conventions if not specified.
}

locals {
  notation_dash = module.std.names.aws.dev.general
  notation_dot  = module.std.names.aws.dev.title
}
```

### Output

```
Changes to Outputs:
  + client  = "clearscale"
  + env     = "dev"
  + name    = "cs-pmod-standards-test-local"
  + names   = {
      + aws = {
          + dev    = {
              + general     = "cs-pmod-dev-use1-standards-test-local"
              + region      = "us-east-1"
              + region_code = "use1"
              + title       = "CsPmod.Dev.USE1.Standards.Test.Local"
            }
          + shared = {
              + general     = "cs-pmod-shared-usw1-dev-standards-test-local"
              + region      = "us-west-1"
              + region_code = "usw1"
              + title       = "CsPmod.Shared.USW1.Dev.Standards.Test.Local"
            }
        }
    }
  + prefix  = "cs-pmod"
  + project = "pmod"
  + region  = "us-west-1"
```

## Notes

Be careful when specifying input variables and take note of the length of the values. Some resources such as IAM have a max character limit of 64. If long values are specified, the generated names may conflict with the AWS resource naming policies.