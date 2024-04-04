output "ftd_01_password" {
  description = "The value of the password for the admin user for the FTD ftd-01."
  value       = module.ftdv_in_cdo.ftd_password
  sensitive   = true
}

output "ftd_01_mgmt_dns" {
  description = "The management interface DNS for the FTD ftd-01."
  value       = module.ftdv_in_cdo.ftd_mgmt_dns
}
