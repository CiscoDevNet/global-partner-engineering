resource "cdo_sdc" "my-sdc" { 
  name = "my-sdc-in-vsphere" 
}

module "vsphere-cdo-sdc" {
  source = "./vsphere_module/"
  vsphere_username     = var.vsphere_username
  vsphere_password     = var.vsphere_password
  vsphere_server       = var.vsphere_server
  datacenter           = var.datacenter
  resource_pool        = var.resource_pool
  cdo_tenant_name      = var.cdo_tenant_name
  datastore            = var.datastore
  network              = var.network
  host                 = var.host
  allow_unverified_ssl = true
  ip_address         = var.ip_address
  gateway            = var.gateway
  cdo_user_password  = var.cdo_user_password
  root_user_password = var.root_user_password
  cdo_bootstrap_data = cdo_sdc.my-sdc.bootstrap_data
}