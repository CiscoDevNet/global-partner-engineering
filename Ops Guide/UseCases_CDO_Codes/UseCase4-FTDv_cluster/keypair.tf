resource "tls_private_key" "key_pair" {
  # algorithm = "RSA"
  # rsa_bits  = 4096
  algorithm = "ED25519"
}

resource "local_file" "this" {
  content       = tls_private_key.key_pair.private_key_openssh
  filename      = "${var.env_name}-private-key.pem"
  file_permission = 0600
}

resource "aws_key_pair" "public_key" {
  key_name   = "${var.env_name}-${random_string.id.result}-key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "random_string" "id" {
  length      = 4
  min_numeric = 4
  special     = false
  lower       = true
}