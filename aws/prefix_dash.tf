locals {
  # Setup the dash notation variables.
  prefix_dash_init_raw = {
    prefix   = replace(lower(replace(local.var_prefix,      "-", " ")), "_", "-")
    name     = replace(lower(replace(local.var_name,        "-", " ")), "_", " ")
    env      = replace(lower(replace(local.out_env,         "-", " ")), "_", " ")
    resource = replace(lower(replace(local.prefix_resource, "-", " ")), "_", " ")
    function = replace(lower(replace(local.prefix_function, "-", " ")), "_", " ")

    region   = ((local.out_region.code == "unk")
      ? lower(local.out_region.short_title_lower)
      : local.out_region.code
    )
  }

  prefix_dash_title = { for key, value in local.prefix_dash_init_raw : key => replace(title(value), " ", "") }
  prefix_dash_init  = { for key, value in local.prefix_dash_init_raw : key => replace(value, " ", "-") }

  # Full name variations in dash notation.
  prefix_dash_full_default = {
    for k, v in {
      default = "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}",
      region  = "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}",
      env = (local.prefix_dash_init.name == local.prefix_dash_init.env
        ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}"
        : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_init.env}"
      ),
      resource = (local.prefix_dash_init.name == local.prefix_dash_init.env
        ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_resource.processed.lookup.title}"
        : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_init.env}-${local.prefix_dash_resource.processed.lookup.title}"
      ),
      function = (local.prefix_dash_init.name == local.prefix_dash_init.env
        ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_resource.processed.lookup.title}-${local.prefix_dash_function.processed.lookup.title}"
        : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_init.env}-${local.prefix_dash_resource.processed.lookup.title}-${local.prefix_dash_function.processed.lookup.title}"
      ),

      template = {
        for tk, tv in {
          default  = "${local.prefix_dash_init.prefix}-{{CONTEXT}}",
          region   = "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-{{REGION}}",
          resource = "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-{{RESOURCE}}",
          function = "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_resource.processed.lookup.title}-{{FX}}"
        }: tk => lower(trimsuffix(replace(tv, "--", "-"), "-"))
      }
    }: k => (k != "template" ? lower(trimsuffix(replace(v, "--", "-"), "-")) : v)
  }

  # Full name variations in dash notation with environment name.
  prefix_dash_full_env = {
    for k, v in {
      default = "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}",
      region  = "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}",
      env = (local.prefix_dash_init.name == local.prefix_dash_init.env
        ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}"
        : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_init.env}"
      ),
      resource = (local.prefix_dash_init.name == local.prefix_dash_init.env
        ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_resource.processed.lookup.title}"
        : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_init.env}-${local.prefix_dash_resource.processed.lookup.title}"
      ),
      function = (local.prefix_dash_init.name == local.prefix_dash_init.env
        ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_resource.processed.lookup.title}-${local.prefix_dash_function.processed.lookup.title}"
        : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_init.env}-${local.prefix_dash_resource.processed.lookup.title}-${local.prefix_dash_function.processed.lookup.title}"
      ),
      template = {
        for tk, tv in {
          default = "${local.prefix_dash_init.prefix}-{{CONTEXT}}",
          region  = "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-{{REGION}}",
          env = (local.prefix_dash_init.name == local.prefix_dash_init.env
            ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}"
            : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-{{ENV}}"
          ),
          resource = (local.prefix_dash_init.name == local.prefix_dash_init.env
            ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-{{RESOURCE}}"
            : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_init.env}-{{RESOURCE}}"
          ),
          function = (local.prefix_dash_init.name == local.prefix_dash_init.env
            ? "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_resource.processed.lookup.title}-{{FX}}"
            : "${local.prefix_dash_init.prefix}-${local.prefix_dash_init.name}-${local.prefix_dash_init.region}-${local.prefix_dash_init.env}-${local.prefix_dash_resource.processed.lookup.title}-{{FX}}"
          ),
        }: tk => lower(trimsuffix(replace(tv, "--", "-"), "-"))
      }
    }: k => (k != "template" ? lower(trimsuffix(replace(v, "--", "-"), "-")) : v)
  }

  # Partial: resource name variations in dash notation.
  prefix_dash_resource = {
    default = {
      name   = local.proc_resource
      title  = local.prefix_dash_title.resource
      upper  = upper(local.proc_resource)
      lower  = lower(local.proc_resource)
      lookup = lookup(local.lookups, local.proc_resource,
        {
          title = local.prefix_dash_title.resource,
          dash  = replace(replace(local.proc_resource, " ", "-"), "_", "-")
          dot   = replace(replace(local.proc_resource, " ", "."), "_", ".")
        }
      )
    }
    processed = {
      name   = local.prefix_resource
      title  = local.prefix_dash_title.resource
      upper  = upper(local.prefix_resource)
      lower  = lower(local.prefix_resource)
      lookup = lookup(local.lookups, local.prefix_resource,
        {
          title = local.prefix_dash_title.resource,
          dash  = replace(replace(local.prefix_resource, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_resource, " ", "."), "_", ".")
        }
      )
    }
  }

  # Partial: function name variations in dash notation.
  prefix_dash_function = {
    default = {
      name   = local.prefix_dash_init.function
      title  = local.prefix_dash_title.function
      upper  = upper(local.prefix_dash_init.function)
      lower  = lower(local.prefix_dash_init.function)
      lookup = lookup(local.lookups, local.prefix_dash_init.function,
        {
          title = local.prefix_dash_title.function,
          dash  = replace(replace(local.prefix_dash_init.function, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_dash_init.function, " ", "."), "_", ".")
        }
      )
    }
    processed = {
      name   = local.prefix_dash_init.function
      title  = local.prefix_dash_title.function
      upper  = upper(local.prefix_dash_init.function)
      lower  = lower(local.prefix_dash_init.function)
      lookup = lookup(local.lookups, local.prefix_dash_init.function,
        {
          title = local.prefix_dash_title.function,
          dash  = replace(replace(local.prefix_dash_init.function, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_dash_init.function, " ", "."), "_", ".")
        }
      )
    }
  }

  #
  # Prefix variations in dash notation.
  #
  prefix_dash = {
    full = {
      default = local.prefix_dash_full_default
      env     = local.prefix_dash_full_env
    }
    resource = local.prefix_dash_resource
    function = local.prefix_dash_function
  }
}