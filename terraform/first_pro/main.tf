module "prod_mod" {
  count  = var.env != "dev" ? 1 : 0
  source = "./module/prod/"
  #  VPC_id = aws_vpc.VPC-MY1.id

}

module "dev_mod" {
  count  = var.env != "prod" ? 1 : 0
  source = "./module/dev/"


}

#module "other_mod" {
#  count  = var.env == "" ? 1 : 0
#  source = "./module/{dev,prod}/"


#}

