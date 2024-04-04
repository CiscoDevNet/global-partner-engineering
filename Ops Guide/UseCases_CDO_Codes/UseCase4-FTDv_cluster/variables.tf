# Env name is tagged on all resources
variable "env_name" {
  default = "NGFW"
}

variable "aws_access_key" {
  type        = string
  sensitive   = true
}
variable "aws_secret_key" {
  type = string
  sensitive = true
}
variable "region" {
  type = string
  default = "us-east-1"
}
variable "aws_az" {
  type = string
  default = "us-east-1a"
}

variable "ftd_pass" {
  type        = string
  sensitive   = true
}

# Service VPC
variable "srvc_cidr" {
  default = "10.0.0.0/16"
}
variable "mgmt_subnet" {
  default = "10.0.0.0/24"
}
variable "data_subnet" {
  default = "10.0.1.0/24"
}
variable "ccl_subnet" {
  default = "10.0.2.0/24"
}
variable "ftd_mgmt_private_ip" {
   type = list(string)
}

variable "ftd_ccl_private_ip" {
   type = list(string)
}

# App VPC
variable "app_cidr" {
  default = "10.1.0.0/16"
}
variable "gwlbe_subnet" {
  default = "10.1.0.0/24"
}
variable "app_subnet" {
  default = "10.1.1.0/24"
}
variable "app_server" {
  default = "10.1.1.100"
}

variable "cdo_api_token" {
  description = "The API token used to authenticate with CDO"
  type        = string
  sensitive   = true
}

variable "cdo_base_url" {
  description = "Specify the base CDO URL"
  type = string
}

variable "counter" {
  type = number
  default = 2
}

variable "ftd_reg_key" {
  type      = string
  sensitive = true
}

variable "ftd_nat_id" {
  type      = string
  sensitive = true
}

variable "ftd_performance_tier" {
  default = "FTDv20"
}

variable "cdo_region" {
  description = "us, eu, apj"
}