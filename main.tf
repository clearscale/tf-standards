locals {
  var_prefix   = replace(replace(replace(var.prefix, "_", "-"), ".", "-"), " ", "-")
  var_client   = replace(replace(replace(var.client, "_", "-"), ".", "-"), " ", "-")
  var_project  = replace(replace(replace(var.project, "_", "-"), ".", "-"), " ", "-")
  var_env      = replace(replace(replace(var.env, "_", "-"), ".", "-"), " ", "-")
  var_region   = replace(replace(replace(var.region, "_", "-"), ".", "-"), " ", "-")
  var_name     = replace(replace(replace(var.name, "_", "-"), ".", "-"), " ", "-")
  var_function = replace(replace(replace(var.function, "_", "-"), ".", "-"), " ", "-")
  var_suffix   = replace(replace(replace(var.suffix, "_", "-"), ".", "-"), " ", "-")

  prefix   = lower(local.var_prefix)
  client   = lower(local.var_client)
  project  = lower(local.var_project)
  region   = lower(local.var_region)
  name     = lower(local.var_name)
  function = lower(local.var_function)
  suffix   = lower(local.var_suffix)

  env = lower((
    (local.var_env == "") ||
    (local.var_env == "default" && terraform.workspace == "default")
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

  accounts_aws = { for aws in module.aws : aws.name => {
    general     = trim("${aws.prefix.dash.full.default.function}-${aws.suffix.dash}", "-_. ")
    title       = trim("${aws.prefix.dot.full.function}.${aws.suffix.dot}", "-_. ")
    region      = aws.region.default
    region_code = aws.region.code
  } }

  names = {
    aws = local.accounts_aws
  }
}

module "aws" {
  source = "./aws"
  count = length([
    for a in try(var.accounts, []) : a
    if lower(trimspace(a.provider)) == "aws"
  ])

  prefix   = local.proc_prefix
  env      = local.env
  key      = var.accounts[count.index].key
  id       = var.accounts[count.index].id
  name     = var.accounts[count.index].name
  region   = coalesce(var.accounts[count.index].region, local.region, "datasource")
  resource = local.name
  function = local.function
  suffix   = local.suffix
}
