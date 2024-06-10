provider "aws" {
  region     = "ap-south-1"
  access_key = "your-access-key" or we can pass variable
  secret_key = "your-security-key" or we can pass variable
}

# Create VPC with (CIDR)
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "engagedly"
  }
}

# Creating Subnets
resource "aws_subnet" "Mysubnet01" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Subnet01"
  }
}

resource "aws_subnet" "Mysubnet02" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Subnet02"
  }
}

resource "aws_subnet" "Mysubnet03" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Subnet03"
  }
}

resource "aws_subnet" "Mysubnet04" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Subnet04"
  }
}

# Creating Internet Gateway IGW
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "MyIGW"
  }
}

# Attaching IGW to VPC
resource "aws_internet_gateway_attachment" "igw_attachment" {
  internet_gateway_id = aws_internet_gateway.myigw.id
  vpc_id              = aws_vpc.myvpc.id
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

# Creating NAT Gateway
resource "aws_nat_gateway" "mynatgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.Mysubnet01.id 
  tags = {
    Name = "MyNatGW"
  }
  depends_on = [aws_internet_gateway.myigw]
}

# Creating Route Table for NAT Gateway
resource "aws_route_table" "nat_routetable" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "MyPrivateRouteTable"
  }
}

# Create a Route in the NAT Route Table with route to NAT Gateway
resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.nat_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mynatgw.id
}

# Associate Subnets with the NAT Route Table
resource "aws_route_table_association" "Mysubnet02_nat_association" {
  route_table_id = aws_route_table.nat_routetable.id
  subnet_id      = aws_subnet.Mysubnet02.id
}

resource "aws_route_table_association" "Mysubnet04_nat_association" {
  route_table_id = aws_route_table.nat_routetable.id
  subnet_id      = aws_subnet.Mysubnet04.id
}


# Creating Route Table for Public Subnet
resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "MyPublicRouteTable"
  }
}

# Create a Route in the Route Table with route to IGW
resource "aws_route" "myigw_route" {
  route_table_id         = aws_route_table.myroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

# Associate Subnets with the Route Table
resource "aws_route_table_association" "Mysubnet01_association" {
  route_table_id = aws_route_table.myroutetable.id
  subnet_id      = aws_subnet.Mysubnet01.id
}

resource "aws_route_table_association" "Mysubnet03_association" {
  route_table_id = aws_route_table.myroutetable.id
  subnet_id      = aws_subnet.Mysubnet03.id
}
