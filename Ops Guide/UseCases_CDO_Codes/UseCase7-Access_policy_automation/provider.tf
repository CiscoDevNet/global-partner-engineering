terraform {
  required_providers {
    fmc = {
      source = "CiscoDevNet/fmc"
    }
	cdo = {
      source  = "CiscoDevnet/cdo"
    }
  }
}

provider "cdo" {
  base_url  = var.cdo_base_url
  api_token = var.cdo_token
}

data "cdo_cdfmc" "current" {
}

provider "fmc" {
  fmc_host          = data.cdo_cdfmc.current.hostname
  is_cdfmc          = true
  cdo_token         = var.cdo_token
  cdfmc_domain_uuid = data.cdo_cdfmc.current.domain_uuid
}