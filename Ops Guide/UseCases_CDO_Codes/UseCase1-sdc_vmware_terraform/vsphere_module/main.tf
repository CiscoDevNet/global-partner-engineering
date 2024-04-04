resource "vsphere_folder" "sdc_folder" {
  path          = local.folder_path
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_content_library" "sdc_content_library" {
  count           = var.sdc_content_library_item_id == null ? 1 : 0
  name            = "${var.cdo_tenant_name}-content-library"
  description     = "Content library to hold SDC OVAs for CDO tenant ${var.cdo_tenant_name}"
  storage_backing = [data.vsphere_datastore.datastore.id]
}

resource "vsphere_content_library_item" "sdc_template" {
  count       = var.sdc_content_library_item_id == null ? 1 : 0
  name        = "cdo-sdc"
  description = "CDO SDC (autoprovisioning enabled)"
  file_url    = var.sdc_ova_location == null ? (var.datacenter_region == "us" ? local.us_ovf_url : local.eu_ovf_url) : var.sdc_ova_location
  library_id  = vsphere_content_library.sdc_content_library[0].id
}

resource "vsphere_virtual_machine" "sdc_vm" {
  name             = "${var.cdo_tenant_name}-sdc2"
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  num_cpus         = local.num_cpus
  memory           = local.memory_mb
  folder           = local.folder_path
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label            = "disk0"
    size             = local.disk_gb
    thin_provisioned = true
  }
  cdrom {
    client_device = true
  }
  clone {
    template_uuid = var.sdc_content_library_item_id == null ? vsphere_content_library_item.sdc_template[0].id : var.sdc_content_library_item_id
  }
  vapp {
    properties = {
      "IP_ADDRESS_CIDR"    = var.ip_address
      "GATEWAY"            = var.gateway
      "CDO_PASS"           = var.cdo_user_password
      "ROOT_PASS"          = var.root_user_password
      "DNS_SERVER"         = var.dns_server
      "CDO_BOOTSTRAP_DATA" = var.cdo_bootstrap_data
      "NTP_SERVER"         = var.ntp_server
    }
  }
  lifecycle {
    ignore_changes = [
      vapp[0].properties,
    ]
  }
}