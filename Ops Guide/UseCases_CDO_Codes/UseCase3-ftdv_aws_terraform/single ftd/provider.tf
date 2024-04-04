terraform {
  required_providers {
    cdo = {
      source  = "CiscoDevnet/cdo"
    }

    aws = {
      source  = "hashicorp/aws"
    }

    tls = {
      source  = "hashicorp/tls"
    }
  }

#  required_version = ">= 1.1"
}

provider "cdo" {
  base_url  = var.cdo_base_url
  api_token = var.cdo_api_token
}

provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "tls" {}