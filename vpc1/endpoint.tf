resource "aws_vpc_endpoint_service" "example" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.my-nlb.arn]
}

resource "aws_vpc_endpoint_service_allowed_principal" "allow_me_to_foo" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.example.id
  principal_arn           = "*"
}

output "name_of_endpoint_service_to_be_given_to_other_party" {
  value = "Name: ${aws_vpc_endpoint_service.example.service_name}"
}
