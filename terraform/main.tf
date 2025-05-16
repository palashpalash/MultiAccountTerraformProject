provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-084568db4383264d4" # Replace with a valid AMI in your region
  instance_type = "t3.micro"
}