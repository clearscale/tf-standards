output "provider" {
  description = "The name of this provider."
  value       = "aws"
}

output "key" {
  description = "The list reference id."
  value       = var.key
}

output "id" {
  description = "The updated account ID."
  value = (length(var.id) < 12
    ? data.aws_caller_identity.current.account_id
    : coalesce(tonumber(var.id), data.aws_caller_identity.current.account_id)
  )
}

output "name" {
  description = "The updated human-readable account name."
  value       = lower(trimspace(replace(var.name, "-", "")))
}

output "region" {
  description = "Region name variants."
  value       = local.out_region
}

output "region_code" {
  description = "Region code name variants."
  value       = local.out_region.code
}

output "env" {
  description = "The updated environment name."
  value       = local.out_env
}

output "prefix" {
  description = "AWS service prefix variants."
  value       = local.out_prefix
}

output "suffix" {
  description = "Suffix variants."
  value       = local.out_suffix
}