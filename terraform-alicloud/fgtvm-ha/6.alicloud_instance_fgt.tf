locals {
  nameEniFgtPort2 = "eni-port2-fgt"
  nameEniFgtPort3 = "eni-port3-fgt"
  nameEniFgtPort4 = "eni-port4-fgt"
}



resource "alicloud_ecs_network_interface" "eniFgtPort2" {
  count                  = 2
  network_interface_name = "${local.nameEniFgtPort2}${count.index + 1}"
  vswitch_id             = var.azList[0] == var.azList[1] ? alicloud_vswitch.vswFgtPort2[0].id : alicloud_vswitch.vswFgtPort2[count.index].id
  security_group_ids     = [alicloud_security_group.sgFgtPrivate.id]

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_ecs_network_interface" "eniFgtPort3" {
  count                  = 2
  network_interface_name = "${local.nameEniFgtPort3}${count.index + 1}"
  vswitch_id             = var.azList[0] == var.azList[1] ? alicloud_vswitch.vswFgtPort3[0].id : alicloud_vswitch.vswFgtPort3[count.index].id
  security_group_ids     = [alicloud_security_group.sgFgtHAMgmt.id]

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_ecs_network_interface" "eniFgtPort4" {
  count                  = local.enablePort4 == true ? 2 : 0
  network_interface_name = "${local.nameEniFgtPort4}${count.index + 1}"
  vswitch_id             = var.azList[0] == var.azList[1] ? alicloud_vswitch.vswFgtPort4[0].id : alicloud_vswitch.vswFgtPort4[count.index].id
  security_group_ids     = [alicloud_security_group.sgFgtHAMgmt.id]

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}



resource "alicloud_ecs_network_interface_attachment" "attachEniFgtPort2" {
  count = 2

  instance_id          = alicloud_instance.fgt[count.index].id
  network_interface_id = alicloud_ecs_network_interface.eniFgtPort2[count.index].id
}

resource "alicloud_ecs_network_interface_attachment" "attachEniFgtPort3" {
  count = 2

  depends_on = [
    alicloud_ecs_network_interface_attachment.attachEniFgtPort2
  ]

  instance_id          = alicloud_instance.fgt[count.index].id
  network_interface_id = alicloud_ecs_network_interface.eniFgtPort3[count.index].id
}

resource "alicloud_ecs_network_interface_attachment" "attachEniFgtPort4" {
  count = local.enablePort4 == true ? 2 : 0

  depends_on = [
    alicloud_ecs_network_interface_attachment.attachEniFgtPort3
  ]

  instance_id          = alicloud_instance.fgt[count.index].id
  network_interface_id = alicloud_ecs_network_interface.eniFgtPort4[count.index].id
}



data "alicloud_ecs_network_interfaces" "dataEniFgtPort3" {
  count = 2
  ids   = [alicloud_ecs_network_interface.eniFgtPort3[count.index].id]
}

data "alicloud_ecs_network_interfaces" "dataEniFgtPort4" {
  count = local.enablePort4 == true ? 2 : 0
  ids   = [alicloud_ecs_network_interface.eniFgtPort4[count.index].id]
}



resource "alicloud_instance" "fgt" {
  count = 2

  depends_on = [
    alicloud_ecs_network_interface.eniFgtPort2,
    alicloud_ecs_network_interface.eniFgtPort3,
    alicloud_ecs_network_interface.eniFgtPort4
  ]

  instance_name        = "FG-${var.CompanyName}-${count.index + 1}"
  security_groups      = alicloud_security_group.sgFgtPublic.*.id
  image_id             = var.amiFgtBYOL70[var.regionName]
  instance_type        = var.instanceTypeFgtFixed
  system_disk_category = var.regionName == "cn-qingdao" ? "cloud_ssd" : "cloud_essd"
  system_disk_size     = 40
  vswitch_id           = var.azList[0] == var.azList[1] ? alicloud_vswitch.vswFgtPort1[0].id : alicloud_vswitch.vswFgtPort1[count.index].id
  instance_charge_type = "PostPaid"
  role_name            = alicloud_ram_role.roleFgtHa.name

  user_data = templatefile("fortigate.conf",
    {
      licenseFile      = var.licenseFiles[count.index]
      licenseType      = "byol"
      adminsPort       = var.portFgtHttps
      enablePrimary    = count.index == 0 ? true : false
      enablePort4      = local.enablePort4
      enableSameAz     = var.azList[0] == var.azList[1] ? true : false
      cidrDestination  = var.cidrVpcNgfw
      ipAddrHAsyncPeer = data.alicloud_ecs_network_interfaces.dataEniFgtPort3[(count.index + 1) % 2].interfaces.0.primary_ip_address
      ipAddrPort3      = data.alicloud_ecs_network_interfaces.dataEniFgtPort3[count.index].interfaces.0.primary_ip_address
      ipAddrPort4      = local.enablePort4 == true ? data.alicloud_ecs_network_interfaces.dataEniFgtPort4[count.index].interfaces.0.primary_ip_address : null
      ipMaskPort3      = cidrnetmask(var.cidrSubnetFgtPort3[count.index])
      ipMaskPort4      = local.enablePort4 == true ? cidrnetmask(var.cidrSubnetFgtPort4[count.index]) : null
      ipAddrPort2Gw    = var.azList[0] == var.azList[1] ? cidrhost(var.cidrSubnetFgtPort2[0], -3) : cidrhost(var.cidrSubnetFgtPort2[count.index], -3)
      ipAddrPort3Gw    = var.azList[0] == var.azList[1] ? cidrhost(var.cidrSubnetFgtPort3[0], -3) : cidrhost(var.cidrSubnetFgtPort3[count.index], -3)
      ipAddrPort4Gw    = var.azList[0] == var.azList[1] ? cidrhost(var.cidrSubnetFgtPort4[0], -3) : cidrhost(var.cidrSubnetFgtPort4[count.index], -3)
      hostname         = "FG-${var.CompanyName}-${count.index + 1}"
    }
  )

  data_disks {
    size                 = 30
    category             = var.regionName == "cn-qingdao" ? "cloud_ssd" : "cloud_essd"
    delete_with_instance = true
  }

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}
