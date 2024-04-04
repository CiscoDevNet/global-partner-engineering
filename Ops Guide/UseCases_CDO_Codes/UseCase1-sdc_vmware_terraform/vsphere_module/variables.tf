variable "vsphere_username" {
  description = "Specify the username for vSphere API operations."
  type        = string
}

variable "vsphere_password" {
  description = "Specify the password for vSphere API operations."
  type        = string
  sensitive = true
}

variable "vsphere_server" {
  description = "Specify the vCenter Server FQDN or IP Address for vSphere API operations."
  type        = string
}

variable "allow_unverified_ssl" {
  description = "Boolean that can be set to true to disable SSL certificate verification. This should be used with care as it could allow an attacker to intercept your authentication token. If omitted, default value is `false`."
  type        = bool
  default     = false
}

variable "datacenter" {
  description = "Specify the name of the [vSphere datacenter](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vcenterhost.doc/GUID-7FDFBDBE-F8AC-4D00-AE5E-3F14D7472FAF.html) where the SDC should be deployed."
  type        = string
}

variable "resource_pool" {
  description = "Specify the name of the [vSphere resource pool](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-resource-management/GUID-60077B40-66FF-4625-934A-641703ED7601.html) where the SDC should be deployed."
  type        = string
}

variable "host" {
  description = "Specify the name of the [vSphere host](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.resmgmt.doc/GUID-487C09CE-8BE2-4B89-BA30-0E4F7E3C66F7.html) to use for the SDC."
  type        = string
}

variable "datastore" {
  description = "Specify the name of the [vSphere datastore](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.storage.doc/GUID-5EE84941-366D-4D37-8B7B-767D08928888.html) to use for the SDC."
  type        = string
}

variable "network" {
  description = "Specify the name of the [vSphere network](hhttps://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.networking.doc/GUID-35B40B0B-0C13-43B2-BC85-18C9C91BE2D4.html) to use for the SDC."
  type        = string
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

variable "dns_server" {
  description = "Specify the DNS servers to use on this VM. Defaults to the Cisco Umbrella DNS server."
  type        = string
  default     = "208.67.222.222"
}

variable "cdo_bootstrap_data" {
  description = "Specify the bootstrap data required to initialize the SDC. The SDC bootstrap data can be generated using the [SDC resource](https://registry.terraform.io/providers/CiscoDevNet/cdo/latest/docs/resources/sdc) in the [CDO Terraform Provider](https://registry.terraform.io/providers/CiscoDevNet/cdo/latest), or using the CDO UI."
  type        = string
}

variable "ntp_server" {
  description = "Specify the NTP server to synchronize the time on this SDC. Defaults to the Ubuntu NTP server."
  type        = string
  default     = "ntp.ubuntu.com"
}

variable "sdc_content_library_item_id" {
  description = "Specify the ID of the content library item that represents the SDC OVA. By default, this module will create a content library item per usage, which can result in excessive space usage if you are deploying SDCs for multiple tenants in a single vSphere instance. If you wish to share the SDC OVA across multiple tenants, specify this value."
  default     = null
  type        = string
}

variable "sdc_ova_location" {
  type        = string
  description = "Specify the location of the OVA file that contains the SDC. You can manually download the S3 OVA to a custom location if you wish to."
  default     = null
}

variable "datacenter_region" {
  description = "Specify the region closest to your vSphere datacenter. Uploading the SDC OVA to your datacenter will be done from a CDO location closest to your region. Allowed values: [eu, us]. You can alternately download the SDC OVA and upload it to a region closer to you."
  validation {
    condition     = contains(["eu", "us"], var.datacenter_region)
    error_message = "Supported regions: [eu, us]. If your datacenter is in another part of the world, use whichever of the EU or US is closer to you geographically."
  }
  type    = string
  default = "us"
}