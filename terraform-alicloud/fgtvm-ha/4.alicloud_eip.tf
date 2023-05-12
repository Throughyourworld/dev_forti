locals {
  nameEipFgt      = "eip-fgt-cluster"
  nameEipMgmtFgt1 = "eip-mgmt-fgt1"
  nameEipMgmtFgt2 = "eip-mgmt-fgt2"
}

locals {
  eipFgtChargeType  = "PayByBandwidth"
  eipFgtPaymentType = "PayAsYouGo"
}

#################### FGT HA EIP ####################
resource "alicloud_eip_address" "eipFgtCluster" {
  count = var.paramEipFgtCluster == "" ? 1 : 0

  address_name         = local.nameEipFgt
  isp                  = "BGP"
  bandwidth            = 10
  internet_charge_type = local.eipFgtChargeType
  payment_type         = local.eipFgtPaymentType

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_eip_association" "eipFgtAssociate" {
  allocation_id = var.paramEipFgtCluster == "" ? alicloud_eip_address.eipFgtCluster[0].id : var.paramEipFgtCluster
  instance_id   = alicloud_instance.fgt[0].id
}



#################### FGT1 EIP Mgmt ####################
resource "alicloud_eip_address" "eipMgmtFgt1" {
  count                = var.paramEipFgtMgmt1 == "" ? 1 : 0
  address_name         = local.nameEipMgmtFgt1
  isp                  = "BGP"
  bandwidth            = 10
  internet_charge_type = local.eipFgtChargeType
  payment_type         = local.eipFgtPaymentType

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_eip_association" "eipMgmtFgt1Associate" {
  instance_type = "NetworkInterface"
  allocation_id = var.paramEipFgtMgmt1 == "" ? alicloud_eip_address.eipMgmtFgt1[0].id : var.paramEipFgtMgmt1
  instance_id   = local.enablePort4 == true ? alicloud_ecs_network_interface.eniFgtPort4[0].id : alicloud_ecs_network_interface.eniFgtPort3[0].id
}



#################### FGT2 EIP Mgmt ####################
resource "alicloud_eip_address" "eipMgmtFgt2" {
  count                = var.paramEipFgtMgmt2 == "" ? 1 : 0
  address_name         = local.nameEipMgmtFgt2
  isp                  = "BGP"
  bandwidth            = 10
  internet_charge_type = local.eipFgtChargeType
  payment_type         = local.eipFgtPaymentType

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_eip_association" "eipMgmtFgt2Associate" {
  instance_type = "NetworkInterface"
  allocation_id = var.paramEipFgtMgmt2 == "" ? alicloud_eip_address.eipMgmtFgt2[0].id : var.paramEipFgtMgmt2
  instance_id   = local.enablePort4 == true ? alicloud_ecs_network_interface.eniFgtPort4[1].id : alicloud_ecs_network_interface.eniFgtPort3[1].id
}
