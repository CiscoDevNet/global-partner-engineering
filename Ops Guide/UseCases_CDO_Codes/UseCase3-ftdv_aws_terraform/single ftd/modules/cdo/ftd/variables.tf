variable "vpc_id" {
  description = "Specify the VPC to deploy the ASA to."
  type        = string
}

variable "private_subnet_id" {
  description = "Specify the ID of the private subnet to deploy the ASA to."
  type        = string
}

variable "public_subnet_id" {
  description = "Specify the ID of the public subnet to deploy the ASA to."
  type        = string
}

variable "ftd_name" {
  description = "Specify the name of the FTD in CDO."
  type        = string
}

variable "cdo_api_token" {
  description = "The API token used to authenticate with CDO. [See here](https://docs.defenseorchestrator.com/c_api-tokens.html#!t-generatean-api-token.html) to learn how to generate an API token."
  type        = string
  sensitive   = true
}