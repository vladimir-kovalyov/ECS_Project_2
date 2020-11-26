# create the VPC
resource "aws_vpc" "jil_vlad_vpc" {
  cidr_block = var.vlc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "acad_jil_vlad_vpc"
  }
}

# create the Subnet
resource "aws_subnet" "jil_vlad_vpc_subnet_one" {
  vpc_id                  = aws_vpc.jil_vlad_vpc.id
  cidr_block              = var.subnet_one
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.aval_zone_one

  tags = {
    Name = "acad_jil_vlad_sub_one"
  }
}

# create secondary subnet
resource "aws_subnet" "jil_vlad_vpc_subnet_two" {
  vpc_id                  = aws_vpc.jil_vlad_vpc.id
  cidr_block              = var.subnet_two
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.aval_zone_two

  tags = {
    Name = "acad_jil_vlad_sub_two"
  }
}

# Create the Security Group
resource "aws_security_group" "jil_vlad_sg" {
  vpc_id      = aws_vpc.jil_vlad_vpc.id
  name        = "Jil Vlad SG for VPC"
  description = "Jil Vlad SG for VPC"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    security_groups = [aws_security_group.jil_vlad_alb_sg.id]
  }

  # allow ingress of port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow ingress of port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Jil Vlad SG for VPC"
    Description = "Jil Vlad SG for VPC"
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "jil_vlad_vpc_gw" {
  vpc_id = aws_vpc.jil_vlad_vpc.id
  tags = {
    Name = "Jil Vlad IG for VPC"
  }
}

# Create the Route Table
resource "aws_route_table" "jil_vlad_rt" {
  vpc_id = aws_vpc.jil_vlad_vpc.id

  tags = {
    Name = "Jil Vlad RT for VPC"
  }
}

# Create the route
resource "aws_route" "jil_vlad_rt_vpc" {
  route_table_id         = aws_route_table.jil_vlad_rt.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.jil_vlad_vpc_gw.id
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "jil_vlad_assoc_sub_one" {
  subnet_id      = aws_subnet.jil_vlad_vpc_subnet_one.id
  route_table_id = aws_route_table.jil_vlad_rt.id
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "jil_vlad_assoc_sub_two" {
  subnet_id      = aws_subnet.jil_vlad_vpc_subnet_two.id
  route_table_id = aws_route_table.jil_vlad_rt.id
}

output "subnet_one_id" {
  value = aws_subnet.jil_vlad_vpc_subnet_one.id
}

output "subnet_two_id" {
  value = aws_subnet.jil_vlad_vpc_subnet_two.id
}

output "vpc_security_group_id" {
  value = aws_security_group.jil_vlad_sg.id
}