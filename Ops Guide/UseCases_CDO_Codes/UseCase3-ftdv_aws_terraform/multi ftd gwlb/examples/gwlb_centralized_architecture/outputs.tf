output "instance_ip" {
  description = "Public IP address of the FTD instances"
  value       = module.instance.instance_private_ip
}

output "generated_command_ftdv0" {
  value       = module.instance.generated_command_ftdv0
}

output "generated_command_ftdv1" {
  value       = module.instance.generated_command_ftdv1
}
