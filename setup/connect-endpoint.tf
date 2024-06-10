resource "aws_ec2_instance_connect_endpoint" "my-ep" {
  subnet_id = "subnet-04be2de09bc3b0d37" 

  tags = {
    Name = "myep"
  }
}
