variable "create_tgw" {
  type = bool
  default = true
}

variable "vpc_service_id" {
  type        = string
  description = "ID of the service VPC"
}
variable "vpc_spoke_id" {
  type        = string
  description = "ID of the Spoke VPC"
}
variable "spoke_subnet_id" {
  type        = list(string)
  description = "ID of the Spoke Subnet"
  default = []
}

variable "tgw_subnet_name" {
  type        = list(string)
  description = "List of name for TGW Subnets"
  default     = []
}

variable "tgw_subnet_cidr" {
  description = "Transit Gateway subnet CIDR"
  type        = list(string)
  default     = []
}

variable "vpc_spoke_cidr" {
  description = "Spoke VPC Subnet CIDR"
  type        = string
}

variable "availability_zone_count" {
  description = "Number of AZ to be used for deployment"
  type        = number
  default     = 2
}

variable "gwlbe" {
  type        = list(string)
  description = "ID of the GWLB Endpoints"
}

variable "transit_gateway_name" {
  type        = string
  description = "Name of the Transit Gateway created"
  default     = null
}

variable "nat_subnet_routetable_ids" {
  type        = list(string)
  description = "list of Route table IDs associated with NAT Subnets"
  default     = []
}

variable "gwlbe_subnet_routetable_ids" {
  type        = list(string)
  description = "list of Route table IDs associated with GWLBE Subnets"
  default     = []
}

variable "spoke_rt_id" {
  type        = list(string)
  description = "Spoke VPC Route table ID"
}
  