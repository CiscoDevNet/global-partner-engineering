# GWLB
resource "aws_lb" "gwlb" {
  name                             = "${var.env_name}-gwlb"
  load_balancer_type               = "gateway"
  subnets                          = [aws_subnet.data_subnet.id]
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.env_name} Security GWLB"
    app  = "service"
  }
}

# TG
resource "aws_lb_target_group" "ftd" {
  name        = "${var.env_name}-ftdtg"
  protocol    = "GENEVE"
  vpc_id      = aws_vpc.srvc_vpc.id
  target_type = "ip"
  port        = 6081
  stickiness {
    type = "source_ip_dest_ip"
  }
  health_check {
    port     = 7777
	protocol = "TCP"
  }
  tags = {
    Name = "${var.env_name} Security GWLB TG"
    app  = "service"
  }
}

resource "aws_lb_target_group_attachment" "ftd" {
  count = var.counter
  target_group_arn = aws_lb_target_group.ftd.arn
  target_id        = aws_network_interface.ftd_data[count.index].private_ip
}

resource "aws_lb_listener" "cluster" {
  load_balancer_arn = aws_lb.gwlb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ftd.arn
  }
  tags = {
    Name = "${var.env_name} Security GWLB Listener"
    app  = "service"
  }
}

resource "aws_vpc_endpoint_service" "gwlb" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
  tags = {
    Name = "${var.env_name} Security GWLB EP Service"
    app  = "service"
  }
}

# GWLB Endpoints
resource "aws_vpc_endpoint" "fw" {
  service_name      = aws_vpc_endpoint_service.gwlb.service_name
  vpc_endpoint_type = aws_vpc_endpoint_service.gwlb.service_type
  vpc_id            = aws_vpc.app_vpc.id
  tags = {
    Name = "${var.env_name } GWLBe"
  }
}

# GWLB Endpoints subnet association
resource "aws_vpc_endpoint_subnet_association" "fw" {
  vpc_endpoint_id = aws_vpc_endpoint.fw.id
  subnet_id       = aws_subnet.gwlbe_subnet.id
}