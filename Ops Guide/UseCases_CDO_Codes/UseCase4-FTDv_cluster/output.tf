output "ftd_public_ip" {
  value = aws_eip.ftd-mgmt-EIP.*.public_ip
}