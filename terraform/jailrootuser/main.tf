terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.app_server.id
}

resource "aws_instance" "app_server" {
  ami               = "ami-089a545a9ed9893b6"
  instance_type     = "t2.micro"
  availability_zone = var.az_name
  key_name          = "5514-bastion-key"
  user_data         = "${data.template_file.userdata_temp.rendered}"
  tags = {
    Name = var.instance_name
  }
}

resource "aws_ebs_volume" "data" {
  availability_zone = var.az_name
  size              = var.volume2_size
}

output "Instance_public_ip" {
  description = "Public ip of the instance"
  value       = aws_instance.app_server.public_ip

}

