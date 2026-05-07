variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.100.0.0/16"
}

variable "public_subnet_1" {
  default = "10.100.1.0/24"
}

variable "public_subnet_2" {
  default = "10.100.2.0/24"
}

variable "private_subnet_1" {
  default = "10.100.3.0/24"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH key name"
  default     = "capstone-key"
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
