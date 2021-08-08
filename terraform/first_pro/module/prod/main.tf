resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "prod-subnet" {
  vpc_id     = aws_vpc.prod_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "prod-subnet"
  }
}


resource "aws_instance" "app_server" {
  ami           = "ami-0b0af3577fe5e3532"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.prod-subnet.id
  key_name      = "ABC"

  tags = {
    Name = "Machine-prod"
  }
}
