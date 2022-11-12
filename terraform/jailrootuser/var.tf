variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}
variable "volume2_size" {
  description = "another volume size"
  type        = string
  default     = "1"
}
variable "az_name" {
  description = "availability zone name"
  type        = string
  default     = "us-east-2c"
}
variable "region" {
  description = "region name to create the ec2"
  type        = string
  default     = "us-east-2"
}
variable "jailroot_username" {
  description = "jail root user name for ec2 instance"
  type        = string
  default     = "ssh"
}
variable "ssh_user_pass" {
  description = "jail root user pass for ec2 instance"
  type        = string
  default     = "1"
}
variable "s3_bucket_path" {
  description = "please enter s3 bucket path from copy data to /data directory on instance"
  type        = string
}
