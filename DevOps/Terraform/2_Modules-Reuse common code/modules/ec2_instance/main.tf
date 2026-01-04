provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami                         = var.ami_value
  instance_type               = var.instance_type_value
  # MUST BE FALSE TO BE FREE (Avoids $0.005/hr IPv4 charge)
  associate_public_ip_address = false 
}