output "sdc_ip" {
  description = "The IP address of the SDC created in Terraform."
  value       = vsphere_virtual_machine.sdc_vm.guest_ip_addresses
}

output "sdc_content_library_item_name" {
  description = "The name of the SDC OVA content library item."
  value       = var.sdc_content_library_item_id == null ? vsphere_content_library_item.sdc_template[0].name : null
}

output "sdc_content_library_id" {
  description = "The ID of the SDC OVA content library."
  value       = var.sdc_content_library_item_id == null ? vsphere_content_library.sdc_content_library[0].id : null
}