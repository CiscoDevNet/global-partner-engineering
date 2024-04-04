terraform {
  required_providers {
    cdo = {
      source  = "CiscoDevnet/cdo"
    }
  }
}
provider "cdo" {
  base_url  = var.cdo_base_url
  api_token = var.cdo_api_token
}