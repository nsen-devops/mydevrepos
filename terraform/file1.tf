provider "aws" {
  access_key = "AKIATAJG4H7VL6TICVG4"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_vpc" "VPC-MY1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "VPC-MY1"
  }
}

resource "aws_subnet" "custom-subnet" {
  vpc_id     = aws_vpc.VPC-MY1.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "custom-subnet"
  }
}

resource "aws_network_interface" "eth0" {
  subnet_id   = aws_subnet.custom-subnet.id
  private_ips = ["10.0.0.200"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0b0af3577fe5e3532"
  instance_type = "t2.micro"
  key_name      = "ABC"

  network_interface {
    network_interface_id = aws_network_interface.eth0.id
    device_index         = 0
  }

  tags = {
    Name = "Machine1"
  }
}
