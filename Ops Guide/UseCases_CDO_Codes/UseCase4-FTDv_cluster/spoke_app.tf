data "aws_ami" "ami_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.ami_linux.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.public_key.key_name
  subnet_id     = aws_subnet.app_subnet.id
  private_ip    = var.app_server
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.app_allow_all.id
  ]
  tags = {
    Name    = "${var.env_name} Spoke App"
  }
}