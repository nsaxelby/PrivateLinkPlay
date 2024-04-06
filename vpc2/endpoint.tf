resource "aws_vpc_endpoint" "other_vpc_endpoint" {
  vpc_id             = aws_vpc.vpc2.id
  service_name       = "INSERT SERVICE ENDPOINT URI HERE"
  subnet_ids         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.endpointsg.id]
}

resource "aws_security_group" "endpointsg" {
  name   = "endpoint_sg"
  vpc_id = aws_vpc.vpc2.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_tcp_endpoint" {
  security_group_id = aws_security_group.endpointsg.id
  cidr_ipv4         = aws_vpc.vpc2.cidr_block
  from_port         = 80
  ip_protocol       = "TCP"
  to_port           = 80
}

output "curl_command_to_use_on_ec2" {
  value = "curl http://${aws_vpc_endpoint.other_vpc_endpoint.dns_entry[0].dns_name}"
}
