
# Create a VPC
resource "aws_vpc" "vpc2" {
  cidr_block = "10.50.0.0/16"
  tags = {
    Name = "vpc2"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.50.1.0/24"

  tags = {
    Name = "public_subnet_1_vpc2"
  }
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.50.2.0/24"

  tags = {
    Name = "public_subnet_2_vpc2"
  }
  availability_zone = "eu-west-1b"
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.50.3.0/24"

  tags = {
    Name = "public_subnet_3_vpc2"
  }
  availability_zone = "eu-west-1c"
}

resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "igw1_vpc2"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc2_igw.id
  }

  tags = {
    Name = "public-rt1_vpc2"
  }
}

resource "aws_route_table_association" "public_rt_assoc_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_subnet_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}
