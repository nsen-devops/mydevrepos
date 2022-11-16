data "template_file" "userdata_temp" {
  template = file("user-data-ssh.sh")
  vars = {
    jailroot_username = "${var.jailroot_username}"
    ssh_user_pass     = "${var.ssh_user_pass}"
    volume2_size      = "${var.volume2_size}"
  }
}

