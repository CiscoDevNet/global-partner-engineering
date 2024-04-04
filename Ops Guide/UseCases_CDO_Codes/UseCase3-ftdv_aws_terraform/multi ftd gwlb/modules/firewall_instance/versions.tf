terraform {
  required_providers {
    cdo = {
      source = "CiscoDevnet/cdo"
    }

    fmc = {
      source  = "CiscoDevNet/fmc"
      version = "1.4.0"
    }
	
	time = {
      source = "hashicorp/time"
      version = "0.10.0"
    }

    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
    template = ">= 2.2.0"
  }
  required_version = ">= 0.13.5"
}

provider "cdo" {
  base_url  = var.cdo_base_url
  api_token = var.cdo_api_token
}

data "cdo_cdfmc" "current" {
}

provider "fmc" {
  fmc_host          = data.cdo_cdfmc.current.hostname
  is_cdfmc          = true
  cdo_token         = var.cdo_api_token
  cdfmc_domain_uuid = data.cdo_cdfmc.current.domain_uuid
}
