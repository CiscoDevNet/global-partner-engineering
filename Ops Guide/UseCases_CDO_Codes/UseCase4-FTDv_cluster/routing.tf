# Mgmt Route Table
resource "aws_route_table" "mgmt_route_table" {
  vpc_id = aws_vpc.srvc_vpc.id
  tags = {
    Name = "${var.env_name} Security Mgmt Route Table"
  }
}

resource "aws_route" "mgmt_default_route" {
  depends_on = [aws_internet_gateway.mgmt_igw]
  route_table_id         = aws_route_table.mgmt_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mgmt_igw.id
}

resource "aws_route_table_association" "mgmt_association" {
  subnet_id      = aws_subnet.mgmt_subnet.id
  route_table_id = aws_route_table.mgmt_route_table.id
}

# Spoke Route Table
resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } Spoke Route Table"
  }
}

resource "aws_route" "app_default_route" {
  depends_on = [aws_vpc_endpoint.fw, aws_vpc_endpoint_subnet_association.fw]
  route_table_id         = aws_route_table.app_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.fw.id
}

resource "aws_route_table_association" "app1_association" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.app_route_table.id
}


# GWLBe Route Table
resource "aws_route_table" "gwlbe_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } GWLBe Route Table"
  }
}

resource "aws_route" "gwlbe_default_route" {
  depends_on = [aws_internet_gateway.app_igw]
  route_table_id         = aws_route_table.gwlbe_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}

resource "aws_route_table_association" "gwlbe_association" {
  subnet_id      = aws_subnet.gwlbe_subnet.id
  route_table_id = aws_route_table.gwlbe_route_table.id
}


# IGW Routing
resource "aws_route_table" "app_igw_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } IGW Route Table"
  }
}

resource "aws_route" "app1_igw_route_app1_subnet" {
  depends_on = [aws_vpc_endpoint.fw, aws_vpc_endpoint_subnet_association.fw]
  route_table_id         = aws_route_table.app_igw_route_table.id
  destination_cidr_block = var.app_subnet
  vpc_endpoint_id        = aws_vpc_endpoint.fw.id
}

resource "aws_route_table_association" "app_igw_association" {
  gateway_id     = aws_internet_gateway.app_igw.id
  route_table_id = aws_route_table.app_igw_route_table.id
}

# Security Mgmt IGW
resource "aws_internet_gateway" "mgmt_igw" {
  vpc_id = aws_vpc.srvc_vpc.id
  tags = {
    Name = "${var.env_name} Security Mgmt-IGW"
  }
}

# Spoke IGW
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } IGW"
  }
}