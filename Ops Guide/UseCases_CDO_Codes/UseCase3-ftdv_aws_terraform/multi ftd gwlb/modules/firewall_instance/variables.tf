variable "ftd_version" {
  description = "specified FTD version."
  type        = string
  default     = "ftdv-7.3.0"
  validation {
    error_message = "Version name should include ftdv- followed by version. Example: ftdv-7.1.0."
    condition     = can(regex("^ftdv-.*", var.ftd_version))
  }
}

variable "keyname" {
  description = "specified key pair name to connect firewall ."
  type        = string
}

variable "instances_per_az" {
  description = "Spacified no. of instance per az wants to be create . "
  type        = number
  default     = 1
}
variable "availability_zone_count" {
  description = "Spacified availablity zone count . "
  type        = number
  default     = 2
}
variable "ftd_size" {
  description = "specified server instance type ."
  type        = string
  default     = "c5.xlarge"
}

variable "ftd_mgmt_interface" {
  description = "list out existing ENI IDs to be used for ftd management interface"
  type        = list(string)
  default     = []
}
variable "ftd_inside_interface" {
  description = "list out existing ENI IDs to be used forftd inside interface"
  type        = list(string)
  default     = []
}
variable "ftd_outside_interface" {
  description = "list out existing ENI IDs to be used for outside interface"
  type        = list(string)
  default     = []
}
variable "ftd_diag_interface" {
  description = "list out existing ENI IDs to be used for digonstic interface"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "map the required tags ."
  type        = map(any)
  default     = {}
}

variable "fmc_hostname" {
  description = "specified fmc hostname ."
  type        = string
  default     = "FMC-01"
}

variable "ftd_name" {
  description = "Specify the name of the FTD in CDO."
  type        = list(string)
}

variable "cdo_api_token" {
  description = "The API token used to authenticate with CDO. [See here](https://docs.defenseorchestrator.com/c_api-tokens.html#!t-generatean-api-token.html) to learn how to generate an API token."
  type        = string
  sensitive   = true
}

variable "cdo_base_url" {
  description = "Specify the base CDO URL. This is the URL you enter when logging into your CDO account."
  type = string
}

variable "ftd_admin_password" {
  type = string
  default = "C1sc0@123"
}

variable "aws_ftd_eip"{
  type = list(string)
}