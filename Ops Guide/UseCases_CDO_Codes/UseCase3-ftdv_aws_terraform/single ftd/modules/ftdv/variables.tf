variable "vpc_id" {
  description = "The AWS VPC to deploy the FTDv in."
  type        = string
}
variable "base_name" {
  description = "The base name is a prefix assigned to all of the resources created for the FTDv. It typically corresponds to the name of the CDO environment that the FTDv will be onboarded to."
  type        = string
}

variable "aws_region" {
  description = "The AWS region the ASAv is being deployed in. This is required in order to wait for the ASAv to become available."
  type        = string
}

variable "public_subnets" {
  description = "The FTDv is deployed with three interfaces (management, outside, and inside) to a AWS VPC with public subnets accessible from the internet, and private subnets inaccessible from the internet. The management and outside interfaces of the FTDv are deployed in the public subnet. Specify the public subnets in the VPC here."
  type        = list(any)
  validation {
    condition     = length(var.public_subnets) >= 1
    error_message = "The FTDv requires at least one subnet that the management and outside interfaces can be deployed to."
  }
}
variable "private_subnets" {
  description = "The FTDv is deployed with three interfaces (management, outside, and inside) to a AWS VPC with public subnets accessible from the internet, and private subnets inaccessible from the internet. The management and outside interfaces of the FTDv are deployed in the public subnet. Specify the private subnets in the VPC here."
  type        = list(any)
  validation {
    condition     = length(var.private_subnets) >= 1
    error_message = "The FTDv requires at least one subnet that the management and outside interfaces can be deployed to."
  }
}
variable "ftd_version" {
  description = "The version of the FTDv to deploy."
  type        = string
  default     = "7.3"
}
variable "ftdv_instance_size" {
  description = "Size of the EC2 instance used to run the SDC). Allowed values: See the [Cisco Secure Firewall Firewall Threat Defense Virtual](https://aws.amazon.com/marketplace/pp/prodview-agotwrhawevmc) page on the AWS Marketplace."
  type        = string
  default     = "c5.xlarge"
}
variable "ftd_hostname" {
  description = "The hostname of the FTDv."
  type        = string
  default     = "FTD-01"
}

variable "ftd_admin_password" {
  description = "Admin Password for the FTD."
  type        = string
}

variable "fmc_reg_key" {
  description = "The registration key shared by the FMC."
  type        = string
}
variable "fmc_nat_id" {
  description = "The NAT ID shared by the FMC. The NAT ID is a one-time password used only during registration."
  type        = string
}

variable "fmc_hostname" {
  description = "The FMC hostname to connect to."
  type        = string
}