# Security Group for Web Server in the public subnet
resource "aws_security_group" "webserver-sg" {
  vpc_id = "vpc-04f00588ffc80f412"
  name        = "web-server_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebServer-SG"
  }
}

# EC2 Instance for Web Server in the public subnet with a public IP address
resource "aws_instance" "web_server_instance" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  key_name      = "general"
  subnet_id     = "subnet-0be2e1faa25b0c380"  # Public subnet
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  associate_public_ip_address = true  # Assign a public IP address to the instance

  tags = {
    Name = "WebServer-public"
  }
}

# Security Group for Postgresql in the private subnet
resource "aws_security_group" "psql-sg" {
  vpc_id = "vpc-04f00588ffc80f412"
  name        = "postres_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "postgres-SG"
  }
}

# EC2 Instance for PostgreSQL in the private subnet
resource "aws_instance" "postgresql_instance" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  key_name      = "general"
  subnet_id     = "subnet-04be2de09bc3b0d37" 
  vpc_security_group_ids = [aws_security_group.psql-sg.id]

  tags = {
    Name = "Postgresq-private"
  }
}
