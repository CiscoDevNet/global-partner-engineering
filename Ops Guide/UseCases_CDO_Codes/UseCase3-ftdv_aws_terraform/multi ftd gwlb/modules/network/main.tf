resource "aws_vpc" "ftd_vpc" {
  count                = var.vpc_cidr != "" ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  #enable_classiclink   = false
  instance_tenancy     = "default"
  tags = merge({
    Name = var.vpc_name
  }, var.tags)
}

resource "aws_subnet" "mgmt_subnet" {
  count                   = length(var.mgmt_subnet_cidr) != 0 ? length(var.mgmt_subnet_cidr) : 0
  vpc_id                  = local.con
  cidr_block              = var.mgmt_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge({
    Name = "${var.mgmt_subnet_name[count.index]}"
  }, var.tags)
}

resource "aws_subnet" "outside_subnet" {
  count             = length(var.outside_subnet_cidr) != 0 ? length(var.outside_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.outside_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge({
    Name = var.outside_subnet_name[count.index]
  }, var.tags)
}

resource "aws_subnet" "inside_subnet" {
  count             = length(var.inside_subnet_cidr) != 0 ? length(var.inside_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.inside_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge({
    Name = var.inside_subnet_name[count.index]
  }, var.tags)
}

resource "aws_subnet" "diag_subnet" {
  count             = length(var.diag_subnet_cidr) != 0 ? length(var.diag_subnet_cidr) : 0
  vpc_id            = local.con
  cidr_block        = var.diag_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge({
    Name = var.diag_subnet_name[count.index]
  }, var.tags)
}

resource "aws_security_group" "outside_sg" {
  name        = "Outside InterfaceSG"
  vpc_id      = local.con
  description = "Secure Firewall OutsideSG"
}

resource "aws_security_group_rule" "outside_sg_ingress" {
  count       = length(var.outside_interface_sg)
  type        = "ingress"
  from_port   = 0
  protocol    = "-1"
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
  description = "All"
  security_group_id = aws_security_group.outside_sg.id
}

resource "aws_security_group_rule" "outside_sg_egress" {
  type              = "egress"
  description       = "Secure Firewall OutsideSG"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.outside_sg.id
}

resource "aws_security_group" "inside_sg" {
  name        = "Inside InterfaceSG"
  vpc_id      = local.con
  description = "Secure Firewall InsideSG"
}

resource "aws_security_group_rule" "inside_sg_ingress" {
  count       = length(var.inside_interface_sg)
  type        = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.inside_sg.id
}

resource "aws_security_group_rule" "inside_sg_egress" {
  type              = "egress"
  description       = "Secure Firewall InsideSG"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.inside_sg.id
}

resource "aws_security_group" "mgmt_sg" {
  name        = "FTD Management InterfaceSG"
  vpc_id      = local.con
  description = "Secure Firewall MGMTSG"
}

resource "aws_security_group_rule" "mgmt_sg_ingress" {
  count       = length(var.mgmt_interface_sg)
  type        = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group_rule" "mgmt_sg_egress" {
  type              = "egress"
  description       = "Secure Firewall MGMTSG"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mgmt_sg.id
}

resource "aws_security_group" "no_access" {
 name        = "No Access"
  vpc_id      = local.con
  description = "No AccessSG"
}

resource "aws_network_interface" "ftd_mgmt" {
  count             = length(var.mgmt_interface) == 0 ? length(var.ftd_mgmt_ip) : 0
  description       = "FTD${count.index}-mgmt"
  subnet_id         = local.mgmt_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_mgmt_ip[count.index]]
  security_groups   = [aws_security_group.mgmt_sg.id]
}

resource "aws_network_interface" "ftd_outside" {
  count             = length(var.outside_interface) == 0 ? length(var.ftd_outside_ip) : 0
  description       = "FTD${count.index}-outside"
  subnet_id         = local.outside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_outside_ip[count.index]]
  security_groups   = [aws_security_group.outside_sg.id]
}


resource "aws_network_interface" "ftd_inside" {
  count             = length(var.inside_interface) == 0 ? length(var.ftd_inside_ip) : 0
  description       = "FTD${count.index}-inside"
  subnet_id         = local.inside_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_inside_ip[count.index]]
  security_groups   = [aws_security_group.inside_sg.id]
}

resource "aws_network_interface" "ftd_diag" {
  count             = length(var.diag_subnet_cidr) != 0 ? length(var.diag_subnet_cidr) : (length(var.diag_subnet_name) != 0 ? length(var.diag_subnet_name) : 0)
  description       = "FTD${count.index}-diag"
  subnet_id         = local.diag_subnet[local.azs[count.index] - 1].id
  source_dest_check = false
  private_ips       = [var.ftd_diag_ip[count.index]]
  security_groups   = [aws_security_group.no_access.id]
}

resource "aws_internet_gateway" "int_gw" {
  vpc_id = local.con
  tags = merge({
    Name = "Internet Gateway"
  }, var.tags)
}

resource "aws_route_table" "ftd_mgmt_route" {
  count  = var.create_igw ? length(local.mgmt_subnet) : 0
  vpc_id = local.con
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.igw
  }

  tags = merge({
    Name = "Management network Routing table ${count.index}"
  }, var.tags)
}

resource "aws_route_table" "ftd_outside_route" {
  count  = length(local.outside_subnet)
  vpc_id = local.con
  tags = merge({
    Name = "outside network Routing table ${count.index}"
  }, var.tags)
}

resource "aws_route_table" "ftd_inside_route" {
  count  = length(local.inside_subnet)
  vpc_id = local.con
  tags = merge({
    Name = "inside network Routing table ${count.index}"
  }, var.tags)
}

resource "aws_route_table" "ftd_diag_route" {
  count  = length(local.diag_subnet)
  vpc_id = local.con
  tags = merge({
    Name = "diag network Routing table ${count.index}"
  }, var.tags)
}

resource "aws_route_table_association" "outside_association" {
  count          = var.rta ? length(local.outside_subnet) : 0
  subnet_id      = local.outside_subnet[count.index].id
  route_table_id = aws_route_table.ftd_outside_route[count.index].id
}

resource "aws_route_table_association" "mgmt_association" {
  count          = var.create_igw ? length(local.mgmt_subnet) : 0
  subnet_id      = local.mgmt_subnet[count.index].id
  route_table_id = aws_route_table.ftd_mgmt_route[count.index].id
}

resource "aws_route_table_association" "inside_association" {
  count          = length(local.inside_subnet)
  subnet_id      = local.inside_subnet[count.index].id
  route_table_id = aws_route_table.ftd_inside_route[count.index].id
}

resource "aws_route_table_association" "diag_association" {
  count          = length(local.diag_subnet)
  subnet_id      = local.diag_subnet[count.index].id
  route_table_id = aws_route_table.ftd_diag_route[count.index].id
}

resource "aws_eip" "ftd_mgmt_eip" {
  count = var.use_ftd_eip ? length(var.mgmt_subnet_name) : 0
  domain= "vpc"
  tags = merge({
    "Name" = "ftd-${count.index} Management IP"
  }, var.tags)
}

resource "aws_eip_association" "ftd_mgmt_ip_assocation" {
  count                = length(aws_eip.ftd_mgmt_eip)
  network_interface_id = aws_network_interface.ftd_mgmt[count.index].id
  allocation_id        = aws_eip.ftd_mgmt_eip[count.index].id
}