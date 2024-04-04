resource "fmc_access_policies" "access_policy" {
  depends_on = [time_sleep.wait]
  name           = "${var.env_name}-Access-Policy"
  default_action = "block"
}

resource "fmc_devices" "ftd" {
  depends_on = [fmc_access_policies.access_policy]
  name = "${var.env_name}-FTDv"
  hostname = aws_eip.ftd-mgmt-EIP[0].public_ip
  regkey = var.ftd_reg_key
  nat_id = var.ftd_nat_id
  performance_tier = var.ftd_performance_tier
  license_caps = ["BASE","URLFilter","THREAT"]
  access_policy {
    id = fmc_access_policies.access_policy.id
    type = "AccessPolicy"
    }
  cdo_host = "www.apj.cdo.cisco.com"
  cdo_region = var.cdo_region
}