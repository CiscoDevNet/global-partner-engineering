terraform { 
  required_providers { 
    cdo = { 
      source = "CiscoDevnet/cdo" 
    }
  } 
} 
provider "vsphere" {
  user           = var.vsphere_username
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

provider "cdo" { 
  base_url = var.cdo_base_url 
  api_token = var.cdo_api_token
} 