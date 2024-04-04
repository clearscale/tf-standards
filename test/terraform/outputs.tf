output "prefix" {
  description = "The updated prefix override for all generated naming conventions."
  value       = module.std.prefix
}

output "client" {
  description = "The updated name of the client."
  value       = module.std.client
}

output "project" {
  description = "The updated name of the client project."
  value       = module.std.project
}

output "names" {
  description = "The updated list of cloud provider account info."
  value       = module.std.names
}

output "env" {
  description = "The updated name of the current environment."
  value       = module.std.env
}

output "region" {
  description = "The updated name of the region."
  value       = module.std.region
}

output "name" {
  description = "The updated name of the resource, application, or service."
  value       = module.std.name
}