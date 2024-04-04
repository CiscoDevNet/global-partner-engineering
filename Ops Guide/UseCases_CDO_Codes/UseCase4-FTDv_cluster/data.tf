data "aws_ami" "ftdv" {
  most_recent = true
  owners = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["ftdv-7.3*"]
  }
  filter {
    name   = "product-code"
    values = ["a8sxy6easi2zumgtyr564z6y7"]
  }
}

data "template_file" "ftd_startup_file" {
  count    = var.counter
  template = file("${path.module}/ftd_startup_file.json")
  vars = {
  	ftd_hostname   = "${var.env_name}-FTDv-${count.index}"
    fmc_reg_key	   = var.ftd_reg_key
	fmc_nat_id 	   = var.ftd_nat_id
    ftd_admin_password = var.ftd_pass
    fmc_hostname   = data.cdo_cdfmc.current.hostname
	cluster_name   = "${var.env_name}-FTDv-Cluster"
  }
}
