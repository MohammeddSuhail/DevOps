variable "aws_region" {
  description = "The AWS region to deploy the instance in"
  type        = string
  default     = "us-east-1"
}

variable "ami_value" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type_value" {
  description = "The instance type (e.g., t3.micro)"
  type        = string
}