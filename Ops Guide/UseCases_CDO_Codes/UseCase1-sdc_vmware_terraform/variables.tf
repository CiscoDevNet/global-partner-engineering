
variable "vsphere_server" {
  description = "Specify the vCenter Server FQDN or IP Address for vSphere API operations."
  type        = string
}

variable "vsphere_username" {
  description = "Specify the username for vSphere API operations."
  type        = string
}

variable "vsphere_password" {
  description = "Specify the password for vSphere API operations."
  type        = string
  sensitive = true
}

variable "datacenter" {
  type        = string
}

variable "resource_pool" {
  type        = string
}

variable "host" {
  type        = string
}

variable "datastore" {
  type        = string
}

variable "network" {
  type        = string
}

variable "cdo_base_url" {
    type = string
}

variable "cdo_api_token" {
    type = string
    sensitive = true
}

variable "cdo_tenant_name" {
  description = "Specify the name of the CDO tenant the SDC is being created for."
  type        = string
}

variable "ip_address" {
  description = "Specify the IP address to be assigned to the VM."
  type        = string
}

variable "gateway" {
  description = "Specify the gateway through which traffic from this VM should be routed. It must be possible to access the internet through this gateway."
  type        = string
}


variable "cdo_user_password" {
  description = "Specify the password for the `cdo` user on this VM. The `cdo` user is a user with `sudo` privileges, and is the user you will use to connect to and perform operations on the VM."
  type        = string
  sensitive   = true
}

variable "root_user_password" {
  description = "Specify the password for the `root` user on this VM."
  type        = string
  sensitive   = true
}