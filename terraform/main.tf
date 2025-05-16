provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-0c02fb55956c7d316" # Replace with a valid AMI in your region
  instance_type = "t2.micro"
}