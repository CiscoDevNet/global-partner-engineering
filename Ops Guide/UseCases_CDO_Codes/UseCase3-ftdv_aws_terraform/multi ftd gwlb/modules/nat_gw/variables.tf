variable "ngw_subnet_cidr" {
  description = "Specified ngw subnet CIDR"
  type        = list(string)
  default     = []
}

variable "ngw_subnet_name" {
  description = "Specified ngw subnet name"
  type        = list(string)
  default     = []
}

variable "availability_zone_count" {
  description = "Specified availablity zone count"
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "Specified VPC ID"
  type        = string
  default     = ""
}
 
variable "internet_gateway" {
  type = string
}

variable "spoke_subnet_cidr" {
  type = list(string)
  default = []
}

variable "gwlb_endpoint_id" {
  type = list(string)
  default = []
}

variable "is_cdfmc" {
  type = bool
  default = false
}

variable "mgmt_rt_id" {
  type = list(string)
  default = []
}