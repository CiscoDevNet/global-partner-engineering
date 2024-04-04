# FTD Management interface
resource "aws_network_interface" "ftd_management" {
  count	          = var.counter
  description     = "ftd_mgmt_if ${count.index}"
  subnet_id       = aws_subnet.mgmt_subnet.id
  security_groups = [aws_security_group.allow_all.id]
  private_ips   = [var.ftd_mgmt_private_ip[count.index]]
  tags = {
    Name = "${var.env_name} Service FTD Mgmt ${count.index}"
  }
}

# FTD Diagnostic interface
resource "aws_network_interface" "ftd_diagnostic" {
  count 		  = var.counter
  description     = "ftd_diag_if ${count.index}"
  subnet_id       = aws_subnet.mgmt_subnet.id
  security_groups = [aws_security_group.allow_all.id]
  tags = {
    Name = "${var.env_name} Service FTD Diag ${count.index}"
  }
}

# FTD Data interface
resource "aws_network_interface" "ftd_data" {
  count				= var.counter
  description       = "ftd_data_if ${count.index}"
  subnet_id         = aws_subnet.data_subnet.id
  security_groups   = [aws_security_group.allow_all.id]
  source_dest_check = false
  tags = {
    Name = "${var.env_name} Service FTD Data ${count.index}"
  }
}

# CCL interfaces
resource "aws_network_interface" "ftd_ccl" {
  count				= var.counter
  description       = "ftd_ccl_if ${count.index}"
  subnet_id         = aws_subnet.ccl_subnet.id
  security_groups   = [aws_security_group.allow_all.id]
  private_ips   	= [var.ftd_ccl_private_ip[count.index]]
  source_dest_check = false
  tags = {
    Name = "${var.env_name} Service FTD CCL ${count.index}"
  }
}

# FTDs
resource "aws_instance" "ftd" {
  count						  = var.counter
  ami                         = data.aws_ami.ftdv.id
  instance_type               = "c5.xlarge"
  key_name                    = aws_key_pair.public_key.key_name
  user_data_replace_on_change = true
  user_data = data.template_file.ftd_startup_file[count.index].rendered

  network_interface {
    network_interface_id = aws_network_interface.ftd_management[count.index].id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.ftd_diagnostic[count.index].id
    device_index         = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.ftd_data[count.index].id
    device_index         = 2
  }
  network_interface {
    network_interface_id = aws_network_interface.ftd_ccl[count.index].id
    device_index         = 3
  }
  tags = {
    Name = "${var.env_name} FTD ${count.index}"
  }
}

resource "time_sleep" "wait" {
  depends_on = [aws_instance.ftd]
  create_duration = "600s"
}

resource "aws_eip" "ftd-mgmt-EIP" {
  count  = var.counter
  depends_on = [aws_internet_gateway.mgmt_igw,aws_instance.ftd]
  tags = {
    Name = "${var.env_name} Security FTD Mgmt EIP ${count.index}"
    app  = "service"
  }
}

resource "aws_eip_association" "ftd-mgmt-ip-assocation" {
  count = var.counter
  network_interface_id = aws_network_interface.ftd_management[count.index].id
  allocation_id        = aws_eip.ftd-mgmt-EIP[count.index].id
}


