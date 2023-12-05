output "prefix" {
  description = "The updated prefix override for all generated naming conventions."
  value       = local.proc_prefix
}

output "client" {
  description = "The updated name of the client."
  value       = local.client
}

output "project" {
  description = "The updated name of the client project."
  value       = local.project
}

output "accounts" {
  description = "The updated list of cloud provider account info."
  value       = local.accounts
}

output "env" {
  description = "The updated name of the current environment."
  value       = local.env
}

output "region" {
  description = "The updated name of the region."
  value       = local.region
}

output "name" {
  description = "The updated name of the resource, application, or service."
  value = trimprefix(trimsuffix(format("%s-%s-%s-%s",
    local.proc_prefix, local.name, local.function, local.suffix
  ), "-"), "-")
}