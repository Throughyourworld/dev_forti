locals {
  prefixSubnetFgtPort1 = "vsw-fgt-port1"
  prefixSubnetFgtPort2 = "vsw-fgt-port2"
  prefixSubnetFgtPort3 = "vsw-fgt-port3"
  prefixSubnetFgtPort4 = "vsw-fgt-port4"
}

locals {
  idVpcNgfw = local.enableNewVpcNgfw == true ? alicloud_vpc.vpcNgfw[0].id : var.paramVpcNgfwId
}

locals {
  azFtntList = [for az in var.azList : "${var.regionName}-${az}"]
}

locals {
  enablePort4 = split(".", var.instanceTypeFgtFixed)[2] == "large" ? false : true
}

resource "alicloud_vswitch" "vswFgtPort1" {
  count = var.azList[0] == var.azList[1] ? 1 : length(var.azList)

  vpc_id       = local.idVpcNgfw
  cidr_block   = var.cidrSubnetFgtPort1[count.index]
  zone_id      = local.azFtntList[count.index]
  vswitch_name = "${local.prefixSubnetFgtPort1}-${local.azFtntList[count.index]}"

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_vswitch" "vswFgtPort2" {
  count = var.azList[0] == var.azList[1] ? 1 : length(var.azList)

  vpc_id       = local.idVpcNgfw
  cidr_block   = var.cidrSubnetFgtPort2[count.index]
  zone_id      = local.azFtntList[count.index]
  vswitch_name = "${local.prefixSubnetFgtPort2}-${local.azFtntList[count.index]}"

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_vswitch" "vswFgtPort3" {
  count = var.azList[0] == var.azList[1] ? 1 : length(var.azList)

  vpc_id       = local.idVpcNgfw
  cidr_block   = var.cidrSubnetFgtPort3[count.index]
  zone_id      = local.azFtntList[count.index]
  vswitch_name = "${local.prefixSubnetFgtPort3}-${local.azFtntList[count.index]}"

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_vswitch" "vswFgtPort4" {
  count = local.enablePort4 == true ? var.azList[0] == var.azList[1] ? 1 : length(var.azList) : 0

  vpc_id       = local.idVpcNgfw
  cidr_block   = var.cidrSubnetFgtPort4[count.index]
  zone_id      = local.azFtntList[count.index]
  vswitch_name = "${local.prefixSubnetFgtPort4}-${local.azFtntList[count.index]}"

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}
