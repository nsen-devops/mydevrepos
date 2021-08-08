resource "aws_vpc" "dev_vpc" {
  cidr_block = "20.0.0.0/16"
}


resource "aws_subnet" "dev-subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "20.0.0.0/24"

  tags = {
    Name = "dev-subnet"
  }
}


resource "aws_instance" "web_server" {
  ami           = "ami-0b0af3577fe5e3532"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.dev-subnet.id
  key_name      = "ABC"

  tags = {
    Name = "Machine-dev"
  }
}
