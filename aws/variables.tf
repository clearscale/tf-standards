variable "prefix" {
  type        = string
  description = "(Optional). Prefix for all generated naming conventions."
  default     = ""
}

variable "name" {
  type        = string
  description = "(Optional). The human-readable name of the AWS account."
  default     = "shared"
}

variable "id" {
  type        = string
  description = "(Optional). The AWS account id."
  default     = "000000000000"
}

variable "region" {
  type        = string
  description = "(Optional). The current region of the account."
  default     = "datasource" # Compute it.
}

variable "env" {
  type        = string
  description = "(Required). Name of the current environment."
}

variable "key" {
  type        = string
  description = "(Optional). The reference key. A developer can use this as a list id in a list of accounts. It must be unique for each list item."
  default     = "current"
}

variable "resource" {
  type        = string
  description = "(Optional). A name of a specific resource, service, module, or identifier. (e.g., CodeCommit, Lambda, CICD (module), etc.)"
  default     = "default"
}

variable "function" {
  type        = string
  description = "(Optional). A name of a specific action performed by var.service. (e.g., get, delete, apply, etc.)"
  default     = "default"
}

variable "suffix" {
  type        = string
  description = "(Optional). An optional suffix to append to the output of any naming conventions."
  default     = null
}