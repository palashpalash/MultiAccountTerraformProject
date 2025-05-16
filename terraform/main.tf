provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-0c1ac8a41498c1a9c" # Replace with a valid AMI in your region
  instance_type = "t3.micro"
}