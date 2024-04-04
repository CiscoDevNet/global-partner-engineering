output "ftd_instance_id" {
  description = "FTD instance ID"
  value       = aws_instance.ftdv.*.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ftdv.*.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ftdv.*.private_ip
}

output "reg_key_ftdv0" {
  value       = cdo_ftd_device.example_ftd[0].reg_key
}

output "nat_id_ftdv0" {
  value       = cdo_ftd_device.example_ftd[0].nat_id
}

output "reg_key_ftdv1" {
  value       = cdo_ftd_device.example_ftd[1].reg_key
}

output "nat_id_ftdv1" {
  value       = cdo_ftd_device.example_ftd[1].nat_id
}

output "generated_command_ftdv0" {
 value = cdo_ftd_device.example_ftd[0].generated_command
}

output "generated_command_ftdv1" {
 value = cdo_ftd_device.example_ftd[1].generated_command
}

