#
# Standards Root Module
#
module "std" {
  source = "../../"

  accounts = [
    { id = "*", name = "dev",    provider = "aws", key = "current", region = "us-east-1"},
    { id = "*", name = "shared", provider = "aws", key = "shared"}
  ]

  prefix   = "cs"
  client   = "ClearScale"
  project  = "pmod"
  env      = "dev"
  region   = "us-west-1"
  name     = "standards"
  function = "test"
  suffix   = "local"
}