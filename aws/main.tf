locals {
  var_prefix   = replace(replace(replace(var.prefix,   "_", "-"), ".", "-"), " ", "-")
  var_name     = replace(replace(replace(var.name,     "_", "-"), ".", "-"), " ", "-")
  var_region   = replace(replace(replace(var.region,   "_", "-"), ".", "-"), " ", "-")
  var_env      = replace(replace(replace(var.env,      "_", "-"), ".", "-"), " ", "-")
  var_resource = replace(replace(replace(var.resource, "_", "-"), ".", "-"), " ", "-")
  var_function = replace(replace(replace(var.function, "_", "-"), ".", "-"), " ", "-")
  var_suffix   = replace(replace(replace(var.suffix,   "_", "-"), ".", "-"), " ", "-")

  prefix   = lower(local.var_prefix)
  name     = lower(local.var_name)
  region   = lower(local.var_region)
  env      = lower(local.var_env)
  resource = lower(local.var_resource)
  function = lower(local.var_function)
  suffix   = lower(local.var_suffix)

  proc_region = (local.region == "datasource"
    ? data.aws_region.current.name
    : local.region
  )
  proc_resource = replace(local.resource, "-", "")
  proc_function = replace(local.function, "-", "")

  prefix_function = (local.proc_function == "default"
    ? ""
    : "${local.function}"
  )
  prefix_resource = (local.proc_resource == "default"
    ? ((length(local.prefix_function) > 0 && local.prefix_function != "default")
      ? "default"
      : ""
    )
    : "${local.resource}"
  )

  out_env = lower((
    (local.var_env  == "") ||
    (local.var_env  == "default" && terraform.workspace == "default")
  ) ? "dev"
    : local.var_env
  )

  # Region name variants
  out_region = {
    default           = lower(trimspace(local.proc_region))
    short             = lower(trimspace(replace(local.proc_region, "-", "")))
    short_title       = replace(title(trimspace(replace(local.proc_region, "-", " "))), " ", "")
    short_title_lower = title(lower(replace(title(trimspace(replace(local.proc_region, "-", " "))), " ", "")))
    title             = replace(title(trimspace(replace(local.proc_region, "-", " "))), " ", "-")
    code              = lookup(local.lookups.region, lower(trimspace(local.proc_region)), "unk")
  }

  # A list of generated prefixes to use across all projects, services, and resources.
  out_prefix = {
    dash = local.prefix_dash
    dot  = local.prefix_dot
  }

  # A list of suffixes in various notations.
  out_suffix = {
    dash = local.suffix
    dot  = replace(title(replace(local.suffix, "-", " ")), " ", ".")
  }
}