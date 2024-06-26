output "nat_rt_id" {
  description = "NAT Gateway subnet Route table ID"
  value       = aws_route_table.ngw_route.*.id
}

output "ngw" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.natgw.*.id
}