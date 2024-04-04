locals {
  # Setup the dot notation variables.
  prefix_dot_init_raw = {
    prefix   = replace(lower(replace(local.var_prefix,      "-", " ")), "_", " ")
    name     = replace(lower(replace(local.var_name,        "-", " ")), "_", " ")
    env      = replace(lower(replace(local.out_env,         "-", " ")), "_", " ")
    resource = replace(lower(replace(local.prefix_resource, "-", " ")), "_", " ")
    function = replace(lower(replace(local.prefix_function, "-", " ")), "_", " ")

    region   = ((local.out_region.code == "unk")
      ? title(local.out_region.short_title)
      : upper(local.out_region.code)
    )
  }

  prefix_dot_title = { for key, value in local.prefix_dot_init_raw : key => replace(title(value), " ", "") }
  prefix_dot_init  = { for key, value in local.prefix_dot_init_raw : key => replace(title(value), " ", "") }

  # Full name in dot notation.
  prefix_dot_full = {
    for k, v in {
      default = "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}",
      region  = "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}",
      env = (local.prefix_dot_init.name == local.prefix_dot_init.env
        ? "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}"
        : "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.${local.prefix_dot_init.env}"
      ),
      resource = (local.prefix_dot_init.name == local.prefix_dot_init.env
        ? "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.${local.prefix_dash_resource.processed.lookup.title}"
        : "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.${local.prefix_dot_init.env}.${local.prefix_dash_resource.processed.lookup.title}"
      ),
      function = (local.prefix_dot_init.name == local.prefix_dot_init.env
        ? "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.${local.prefix_dash_resource.processed.lookup.title}.${local.prefix_dash_function.processed.lookup.title}"
        : "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.${local.prefix_dot_init.env}.${local.prefix_dash_resource.processed.lookup.title}.${local.prefix_dash_function.processed.lookup.title}"
      ),
      template = {
        for tk, tv in {
          default = "${local.prefix_dot_init.prefix}.{{context}}",
          region  = "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.{{region}}",
          env = (local.prefix_dot_init.name == local.prefix_dot_init.env
            ? "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}"
            : "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.{{env}}"
          ),
          resource = (local.prefix_dot_init.name == local.prefix_dot_init.env
            ? "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.{{resource}}"
            : "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.${local.prefix_dot_init.env}.{{resource}}"
          ),
          function = (local.prefix_dot_init.name == local.prefix_dot_init.env
            ? "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.${local.prefix_dash_resource.processed.lookup.title}.{{fx}}"
            : "${local.prefix_dot_init.prefix}.${local.prefix_dot_init.name}.${local.prefix_dot_init.region}.${local.prefix_dot_init.env}.${local.prefix_dash_resource.processed.lookup.title}.{{fx}}"
          ),
        }: tk => trimsuffix(replace(tv, "..", "."), ".")
      }
    }: k => (k != "template" ? trimsuffix(replace(v, "..", "."), ".") : v)
  }

  # Partial: resource name variations in dot notation.
  prefix_dot_resource = {
    default = {
      name   = replace(local.prefix_dot_init.resource,        "-", ".")
      title  = replace(local.prefix_dot_title.resource,       "-", ".")
      upper  = replace(upper(local.prefix_dot_init.resource), "-", ".")
      lower  = replace(lower(local.prefix_dot_init.resource), "-", ".")
      lookup = lookup(local.lookups, local.prefix_dot_init.resource,
        {
          title = local.prefix_dot_init.resource
          dash  = replace(replace(local.prefix_dot_init.resource, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_dot_init.resource, " ", "."), "_", ".")
        }
      )
    }
    processed = {
      name   = replace(local.prefix_dot_init.resource,        "-", ".")
      title  = replace(local.prefix_dot_title.resource,       "-", ".")
      upper  = replace(upper(local.prefix_dot_init.resource), "-", ".")
      lower  = replace(lower(local.prefix_dot_init.resource), "-", ".")
      lookup = lookup(local.lookups, local.prefix_dot_init.resource,
        {
          title = replace(local.prefix_dot_title.resource,        "-", "."),
          dash  = replace(replace(local.prefix_dot_init.resource, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_dot_init.resource, " ", "."), "_", ".")
        }
      )
    }
  }

  # Partial: function name variations in dot notation.
  prefix_dot_function = {
    default = {
      name   = replace(local.prefix_dot_init.function,        "-", ".")
      title  = replace(local.prefix_dot_title.function,       "-", ".")
      upper  = replace(upper(local.prefix_dot_init.function), "-", ".")
      lower  = replace(lower(local.prefix_dot_init.function), "-", ".")
      lookup = lookup(local.lookups, local.prefix_dot_init.function,
        {
          title = replace(local.prefix_dot_title.function,       "-", "."),
          dash  = replace(replace(local.prefix_dot_init.function, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_dot_init.function, " ", "."), "_", ".")
        }
      )
    }
    processed = {
      name   = replace(local.prefix_dot_init.function,        "-", ".")
      title  = replace(local.prefix_dot_title.function,       "-", ".")
      upper  = replace(upper(local.prefix_dot_init.function), "-", ".")
      lower  = replace(lower(local.prefix_dot_init.function), "-", ".")
      lookup = lookup(local.lookups, local.prefix_dot_init.function,
        {
          title = replace(local.prefix_dot_title.function,        "-", "."),
          dash  = replace(replace(local.prefix_dot_init.function, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_dot_init.function, " ", "."), "_", ".")
        }
      )
    }
  }

  #
  # Prefix variations in dot notation.
  #
  prefix_dot = {
    full     = local.prefix_dot_full
    resource = local.prefix_dot_resource
    function = local.prefix_dot_function
  }
}