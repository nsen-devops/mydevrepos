resource "null_resource" "s3copy" {
    depends_on = [ aws_instance.app_server ]
    connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("/root/terraform/5514-bastion-key.pem")
        host     = aws_instance.app_server.public_ip
    }

    provisioner "remote-exec" {
        inline = [
          "sudo aws s3 sync s3://codepipeline-us-east-2-537494711157/test/SourceArti/ /data/"
        ]
    }
}
