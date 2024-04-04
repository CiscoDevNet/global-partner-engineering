resource "fmc_access_policies" "fmc_access_policy" {
  name           = "Default Terraform Access Policy"
  default_action = "block"
}

resource "cdo_ftd_device" "example_ftd" {
  count         	 = var.instances_per_az * var.availability_zone_count
  access_policy_name = fmc_access_policies.fmc_access_policy.name
  licenses           = ["BASE"]
  name               = var.ftd_name[count.index]
  virtual            = true
  performance_tier   = "FTDv50"
}

resource "aws_instance" "ftdv" {
  depends_on    = [cdo_ftd_device.example_ftd]
  count         = var.instances_per_az * var.availability_zone_count
  ami           = data.aws_ami.ftdv.id
  instance_type = var.ftd_size
  key_name      = var.keyname
  metadata_options {
    http_endpoint = "enabled"
  }
  network_interface {
    network_interface_id = element(var.ftd_mgmt_interface, count.index)
    device_index         = 0
  }
  network_interface {
    network_interface_id = element(var.ftd_diag_interface, count.index)
    device_index         = 1
  }
  network_interface {
    network_interface_id = element(var.ftd_outside_interface, count.index)
    device_index         = 2
  }
  network_interface {
    network_interface_id = element(var.ftd_inside_interface, count.index)
    device_index         = 3
  }
  user_data = data.template_file.ftd_startup_file[count.index].rendered
  tags = merge({
    Name = "Cisco ftdv${count.index}"
  }, var.tags)
}

resource "time_sleep" "wait" {
  depends_on = [aws_instance.ftdv]
  create_duration = "600s"
}

resource "cdo_ftd_device_onboarding" "example_ftd" {
  depends_on = [time_sleep.wait]
  count      = var.instances_per_az * var.availability_zone_count
  ftd_uid    = cdo_ftd_device.example_ftd[count.index].id
}

resource "local_file" "generated_ftd" {
	count = 2
	content  = cdo_ftd_device.example_ftd[count.index].generated_command
    filename = "${path.module}/file_${count.index}.txt"
}