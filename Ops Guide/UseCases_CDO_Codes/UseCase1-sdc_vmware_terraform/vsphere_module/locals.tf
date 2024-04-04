locals {
  us_ovf_url  = "https://s3.us-east-2.amazonaws.com/dl.sdc.us-east-2.labs.cdo.cisco.com/CDO-SDC-AUTOPROVISIONED-VM-50105b2.ova"
  eu_ovf_url  = "https://s3.eu-central-1.amazonaws.com/dl.sdc.eu-central-1.labs.cdo.cisco.com/CDO-SDC-AUTOPROVISIONED-VM-50105b2.ova"
  folder_path = "cdo-tenant-${var.cdo_tenant_name}"
  memory_mb   = 4096
  disk_gb     = 64
  num_cpus    = 2
}