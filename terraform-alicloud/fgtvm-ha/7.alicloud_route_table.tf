locals {
  nameRtbPrivate = "rtb-fgt-private"
}

#################### Route Table Fgt Private (port2) ####################
resource "alicloud_route_table" "rtbFgtPrivate" {
  depends_on       = [alicloud_vswitch.vswFgtPort2]
  vpc_id           = local.idVpcNgfw
  route_table_name = local.nameRtbPrivate

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

# routetable <-> vsw association
resource "alicloud_route_table_attachment" "associateVswFgtPort2" {
  count          = var.azList[0] == var.azList[1] ? 1 : length(var.azList)
  depends_on     = [alicloud_route_table.rtbFgtPrivate]
  vswitch_id     = alicloud_vswitch.vswFgtPort2[count.index].id
  route_table_id = alicloud_route_table.rtbFgtPrivate.id
}

# UDR(User Defined Routes) DEFINITION
resource "alicloud_route_entry" "privateDefaultGWv4" {
  depends_on = [alicloud_route_table.rtbFgtPrivate]

  # The Default Route
  route_table_id        = alicloud_route_table.rtbFgtPrivate.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NetworkInterface"
  nexthop_id            = alicloud_ecs_network_interface.eniFgtPort2[0].id
}
