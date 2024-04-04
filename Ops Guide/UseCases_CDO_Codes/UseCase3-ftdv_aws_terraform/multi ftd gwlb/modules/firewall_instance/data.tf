data "aws_ami" "ftdv" {
  most_recent = true
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["${var.ftd_version}*"]
  }

  filter {
    name   = "product-code"
    values = ["a8sxy6easi2zumgtyr564z6y7"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "ftd_startup_file" {
  count    = var.instances_per_az * var.availability_zone_count
  template = file("${path.module}/ftd_startup_file.json")
  vars = {
  	ftd_hostname   = "AWS_FTD ${count.index}"
    fmc_reg_key	   = cdo_ftd_device.example_ftd[count.index].reg_key
	fmc_nat_id 	   = cdo_ftd_device.example_ftd[count.index].nat_id
    ftd_admin_password = var.ftd_admin_password
    fmc_hostname   = data.cdo_cdfmc.current.hostname
  }
}
