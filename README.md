# PrivateLink testing

This repo is for testing/playing with AWS PrivateLink. It includes an example implementation of exposing a simple service (an ALB with direct response) to another VPC via PrivateLink.

There are two VPCs.

VPC1 (`/vpc1`) is the service endpoint - it has an NLB, which points to an ALB, and that ALB has a fixed response of `pong` on all requests on port 80. VPC1 must be created before VPC2.

VPC2 (`/vpc2`) is the consumer VPC. We create a VPC endpoint which points towards the servic endpoint. We must pass the auto-generated service endpoint to (`/vpc2/endpoint.tf  aws_vpc_endpoint.other_vpc_endpoint.service_name`) after VPC1 has been created. VPC2 has an EC2 instance within it, so that we can test the PrivateLink connection.

# Running
Up VPC 1 first

`cd vpc1`
`terraform apply`

Copy the service endpoint to be given to VPC2, it will be writtent to output after apply, e.g.:
`name_of_endpoint_service_to_be_given_to_other_party = "Name: com.amazonaws.vpce.eu-west-1.vpce-svc-0f0a99340244957ef"`
Copy the part after the "Name: "

Paste that into `/vpc2/endpoint.tf` where it says `INSERT SERVICE ENDPOINT URI HERE`

We can then switch to create the VPC2 components:

`cd ..`
`cd vpc2`
`terraform apply`

You now need to go into AWS console and accept the incoming connection request manually, see here: `https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html#accept-reject-connection-requests` for more info.
(VPCS -> Endpoint Services -> Endpoint Connections -> Actions -> Accept)

# Testing
ssh into your ec2 instance in `vpc2`
`ssh ec2-user@your-ec2-ip-here -i cert.pem`

Test you can access the endpoint service using curl:
`curl http://your-endpoint-address-here` - note: this is output to console after create, or you can find it on the endpoint in AWS console. It will look like this in output:
`curl_command_to_use_on_ec2 = "curl http://vpce-00a866d3aa06f531b-624dusee.vpce-svc-03d64a56a1b1512f1.eu-west-1.vpce.amazonaws.com"`