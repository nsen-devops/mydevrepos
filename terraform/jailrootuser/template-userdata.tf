data "template_file" "userdata_temp" {
  template = file("user-data-ssh.sh")
  vars = {
    jailroot_username = "${var.jailroot_username}"
    ssh_user_pass     = "${var.ssh_user_pass}"
    s3_bucket_path    = "${var.s3_bucket_path}"
  }
}

