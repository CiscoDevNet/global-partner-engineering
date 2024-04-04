terraform {
  required_providers {
    cdo = {
      source = "CiscoDevNet/cdo"
	  version = "1.0.8"
    }
	
	vsphere = {
      source = "hashicorp/vsphere"
	  version = "2.6.1"
    }
	
	fmc = {
      source = "CiscoDevNet/fmc"
    }
	
	time = {
      source = "hashicorp/time"
    }
  }
}

data "cdo_cdfmc" "current" {
}

provider "fmc" {
  fmc_host          = data.cdo_cdfmc.current.hostname
  is_cdfmc          = true
  cdo_token         = var.cdo_api_token
  cdfmc_domain_uuid = data.cdo_cdfmc.current.domain_uuid
}

provider "cdo" { 
  base_url = var.cdo_base_url 
  api_token = var.cdo_api_token
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}














