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
  ami                  = "ami-089a545a9ed9893b6"
  instance_type        = "t2.micro"
  availability_zone    = var.az_name
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name
  key_name             = "5514-bastion-key"
  user_data            = data.template_file.userdata_temp.rendered
#  connection {
#    type     = "ssh"
#    user     = "ec2-user"
#    private_key = file("/root/terraform/5514-bastion-key.pem")
#    host     = self.public_ip
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sudo aws s3 sync s3://elasticbeanstalk-us-east-1-551430607006/resources/ /data/"
#    ]
#  }
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

