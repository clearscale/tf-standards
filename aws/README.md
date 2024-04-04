# ClearScale/Terraform Standards: AWS

This submodule is designed to create standardized naming conventions for AWS resources. It produces and outputs a range of formatted and template-based strings, all derived from the provided input variables.

## Usage

```terraform
module "aws" {
  source = "./aws"

  prefix    = "cs-pmod"
  env       = "dev"
  key       = "current"
  id        = "12345678910"
  name      = "dev"
  region   = "us-west-1"
  resource = "standards"
  function = "test"
  suffix   = "local"
}

locals {
  notation_dash = module.aws.prefix.dash.full.default.function
  notation_dot  = module.aws.prefix.dot.full.function
}
```

### Output

```
{
  "id": "123456789012",
  "key": "current",
  "name": "dev",
  "prefix": {
    "dash": {
      "full": {
        "default": {
          "default": "cs-pmod-dev",
          "env": "cs-pmod-dev-usw1",
          "function": "cs-pmod-dev-usw1-standards-test",
          "region": "cs-pmod-dev-usw1",
          "resource": "cs-pmod-dev-usw1-standards",
          "template": {
            "default": "cs-pmod-{{context}}",
            "function": "cs-pmod-dev-usw1-standards-{{fx}}",
            "region": "cs-pmod-dev-{{region}}",
            "resource": "cs-pmod-dev-usw1-{{resource}}"
          }
        },
        "env": {
          "default": "cs-pmod-dev",
          "env": "cs-pmod-dev-usw1",
          "function": "cs-pmod-dev-usw1-standards-test",
          "region": "cs-pmod-dev-usw1",
          "resource": "cs-pmod-dev-usw1-standards",
          "template": {
            "default": "cs-pmod-{{context}}",
            "env": "cs-pmod-dev-usw1",
            "function": "cs-pmod-dev-usw1-standards-{{fx}}",
            "region": "cs-pmod-dev-{{region}}",
            "resource": "cs-pmod-dev-usw1-{{resource}}"
          }
        }
      },
      "function": {
        "default": {
          "lookup": {
            "dash": "test",
            "dot": "test",
            "title": "Test"
          },
          "lower": "test",
          "name": "test",
          "title": "Test",
          "upper": "TEST"
        },
        "processed": {
          "lookup": {
            "dash": "test",
            "dot": "test",
            "title": "Test"
          },
          "lower": "test",
          "name": "test",
          "title": "Test",
          "upper": "TEST"
        }
      },
      "resource": {
        "default": {
          "lookup": {
            "dash": "standards",
            "dot": "standards",
            "title": "Standards"
          },
          "lower": "standards",
          "name": "standards",
          "title": "Standards",
          "upper": "STANDARDS"
        },
        "processed": {
          "lookup": {
            "dash": "standards",
            "dot": "standards",
            "title": "Standards"
          },
          "lower": "standards",
          "name": "standards",
          "title": "Standards",
          "upper": "STANDARDS"
        }
      }
    },
    "dot": {
      "full": {
        "default": "CsPmod.Dev",
        "env": "CsPmod.Dev.USW1",
        "function": "CsPmod.Dev.USW1.Standards.Test",
        "region": "CsPmod.Dev.USW1",
        "resource": "CsPmod.Dev.USW1.Standards",
        "template": {
          "default": "CsPmod.{{context}}",
          "env": "CsPmod.Dev.USW1",
          "function": "CsPmod.Dev.USW1.Standards.{{fx}}",
          "region": "CsPmod.Dev.{{region}}",
          "resource": "CsPmod.Dev.USW1.{{resource}}"
        }
      },
      "function": {
        "default": {
          "lookup": {
            "dash": "Test",
            "dot": "Test",
            "title": "Test"
          },
          "lower": "test",
          "name": "Test",
          "title": "Test",
          "upper": "TEST"
        },
        "processed": {
          "lookup": {
            "dash": "Test",
            "dot": "Test",
            "title": "Test"
          },
          "lower": "test",
          "name": "Test",
          "title": "Test",
          "upper": "TEST"
        }
      },
      "resource": {
        "default": {
          "lookup": {
            "dash": "Standards",
            "dot": "Standards",
            "title": "Standards"
          },
          "lower": "standards",
          "name": "Standards",
          "title": "Standards",
          "upper": "STANDARDS"
        },
        "processed": {
          "lookup": {
            "dash": "Standards",
            "dot": "Standards",
            "title": "Standards"
          },
          "lower": "standards",
          "name": "Standards",
          "title": "Standards",
          "upper": "STANDARDS"
        }
      }
    }
  },
  "provider": "aws",
  "region": {
    "code": "usw1",
    "default": "us-west-1",
    "short": "uswest1",
    "short_title": "UsWest1",
    "short_title_lower": "Uswest1",
    "title": "Us-West-1"
  }
}
```