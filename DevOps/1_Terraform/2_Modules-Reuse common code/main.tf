provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source              = "./modules/ec2_instance"
  # This is the verified Free Tier Amazon Linux 2023 AMI for us-east-1 (x86)
  ami_value           = "ami-0b72821e2f351e396" 
  instance_type_value = "t3.micro"
}