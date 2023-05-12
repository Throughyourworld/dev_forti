locals {
  enableNewVpcNgfw = var.paramVpcNgfwId == "" ? true : false
}

resource "alicloud_vpc" "vpcNgfw" {
  count = local.enableNewVpcNgfw == true ? 1 : 0

  cidr_block = var.cidrVpcNgfw
  vpc_name   = var.nameVpcNgfw

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}
