locals {
  # Setup the dot notation variables.
  prefix_dot_init = {
    prefix   = replace(title(replace(local.var_prefix,      "-", " ")), " ", "")
    name     = replace(title(replace(local.var_name,        "-", " ")), " ", "")
    region   = local.out_region.short_title_lower
    env      = replace(title(replace(local.out_env,         "-", " ")), " ", "")
    resource = replace(title(replace(local.prefix_resource, "-", " ")), " ", "")
    function = replace(title(replace(local.prefix_function, "-", " ")), " ", "")
  }

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
      name   = replace(local.proc_resource,        "-", ".")
      title  = replace(title(local.proc_resource), "-", ".")
      upper  = replace(upper(local.proc_resource), "-", ".")
      lower  = replace(lower(local.proc_resource), "-", ".")
      lookup = lookup(local.lookups, local.proc_resource,
        {
          title = title(local.proc_resource),
          dash  = replace(replace(local.proc_resource, " ", "-"), "_", "-")
          dot   = replace(replace(local.proc_resource, " ", "."), "_", ".")
        }
      )
    }
    processed = {
      name   = replace(local.prefix_resource,        "-", ".")
      title  = replace(title(local.prefix_resource), "-", ".")
      upper  = replace(upper(local.prefix_resource), "-", ".")
      lower  = replace(lower(local.prefix_resource), "-", ".")
      lookup = lookup(local.lookups, local.prefix_resource,
        {
          title = title(local.prefix_resource),
          dash  = replace(replace(local.prefix_resource, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_resource, " ", "."), "_", ".")
        }
      )
    }
  }

  # Partial: function name variations in dot notation.
  prefix_dot_function = {
    default = {
      name   = replace(local.proc_function,        "-", ".")
      title  = replace(title(local.proc_function), "-", ".")
      upper  = replace(upper(local.proc_function), "-", ".")
      lower  = replace(lower(local.proc_function), "-", ".")
      lookup = lookup(local.lookups, local.proc_function,
        {
          title = title(local.proc_function),
          dash  = replace(replace(local.proc_function, " ", "-"), "_", "-")
          dot   = replace(replace(local.proc_function, " ", "."), "_", ".")
        }
      )
    }
    processed = {
      name   = replace(local.prefix_function,        "-", ".")
      title  = replace(title(local.prefix_function), "-", ".")
      upper  = replace(upper(local.prefix_function), "-", ".")
      lower  = replace(lower(local.prefix_function), "-", ".")
      lookup = lookup(local.lookups, local.prefix_function,
        {
          title = title(local.prefix_function),
          dash  = replace(replace(local.prefix_function, " ", "-"), "_", "-")
          dot   = replace(replace(local.prefix_function, " ", "."), "_", ".")
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