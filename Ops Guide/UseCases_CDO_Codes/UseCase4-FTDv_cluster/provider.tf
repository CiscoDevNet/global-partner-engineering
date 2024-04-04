terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
	
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
  }
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     =  var.region
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


