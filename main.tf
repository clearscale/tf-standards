locals {
  var_prefix   = replace(replace(replace(var.prefix,   "_", "-"), ".", "-"), " ", "-")
  var_client   = replace(replace(replace(var.client,   "_", "-"), ".", "-"), " ", "-")
  var_project  = replace(replace(replace(var.project,  "_", "-"), ".", "-"), " ", "-")
  var_env      = replace(replace(replace(var.env,      "_", "-"), ".", "-"), " ", "-")
  var_region   = replace(replace(replace(var.region,   "_", "-"), ".", "-"), " ", "-")
  var_name     = replace(replace(replace(var.name,     "_", "-"), ".", "-"), " ", "-")
  var_function = replace(replace(replace(var.function, "_", "-"), ".", "-"), " ", "-")
  var_suffix   = replace(replace(replace(var.suffix,   "_", "-"), ".", "-"), " ", "-")

  prefix   = lower(local.var_prefix)
  client   = lower(local.var_client)
  project  = lower(local.var_project)
  region   = lower(local.var_region)
  name     = lower(local.var_name)
  function = lower(local.var_function)
  suffix   = lower(local.var_suffix)

  env = lower((
    (local.var_env  == "") ||
    (local.var_env  == "default" && terraform.workspace == "default")
  ) ? "dev"
    : local.var_env
  )

  proc_prefix = (coalesce(
    (local.prefix != "" && local.prefix != local.project
      ? "${local.prefix}-${local.project}"
      : (local.prefix != "" ? local.prefix : null)
    ),
    "${local.client}-${local.project}")
  )

  accounts_aws = [for aws in module.aws : {
    provider = aws.provider
    key      = aws.key
    id       = aws.id
    name     = aws.name
    region   = aws.region
    prefix   = aws.prefix
  }]

  accounts = {
    aws = local.accounts_aws
  }
}

module "aws" {
  source = "./aws"
  count  = length([
    for a in try(var.accounts, []) : a
      if lower(trimspace(a.provider)) == "aws"
  ])

  providers = { aws = aws }
  prefix    = local.proc_prefix
  env       = local.env
  key       = var.accounts[count.index].key
  id        = var.accounts[count.index].id
  name      = var.accounts[count.index].name
  region    = coalesce(var.accounts[count.index].region, local.region, "datasource")
  resource  = local.name
  function  = local.function
  suffix    = local.suffix
}

#
# These values must be hardcoded. We can't use variables here.
# https://developer.hashicorp.com/terraform/language/providers/requirements
# https://registry.terraform.io/browse/providers
#
terraform {
  required_version = ">= 1.6.1"
}