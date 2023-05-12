locals {
  nameSgFgtPort1 = "sg_fgt_public"
  nameSgFgtPort2 = "sg_fgt_private"
  nameSgFgtPort3 = "sg_fgt_hamgmt"
}


resource "alicloud_security_group" "sgFgtPublic" {
  name        = local.nameSgFgtPort1
  description = local.nameSgFgtPort1
  vpc_id      = local.idVpcNgfw

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

locals {
  sgFgtPublic = {
    icmp = {
      description = "ICMP"
      ip_protocol = "icmp"
      port_range  = "-1/-1"
      cidr_ip     = "0.0.0.0/0"
    },
    ssh = {
      description = "SSH"
      ip_protocol = "tcp"
      port_range  = "22/22"
      cidr_ip     = "0.0.0.0/0"
    },
    fgthttps = {
      description = "FGTHTTPS"
      ip_protocol = "tcp"
      port_range  = "${var.portFgtHttps}/${var.portFgtHttps}"
      cidr_ip     = "0.0.0.0/0"
    },
    vpn-ike = {
      description = "VPN-IKE"
      ip_protocol = "udp"
      port_range  = "500/500"
      cidr_ip     = "0.0.0.0/0"
    },
    vpn-natt = {
      description = "VPN-NATT"
      ip_protocol = "udp"
      port_range  = "4500/4500"
      cidr_ip     = "0.0.0.0/0"
    }
  }
}

resource "alicloud_security_group_rule" "sgRuleFgtPublicIngress" {
  for_each = local.sgFgtPublic

  type              = "ingress"
  policy            = "accept"
  nic_type          = "intranet"
  description       = lookup(each.value, "description", null)
  ip_protocol       = lookup(each.value, "ip_protocol", null)
  cidr_ip           = lookup(each.value, "cidr_ip", null)
  port_range        = lookup(each.value, "port_range", null)
  security_group_id = alicloud_security_group.sgFgtPublic.id
}



resource "alicloud_security_group" "sgFgtPrivate" {
  name        = local.nameSgFgtPort2
  description = local.nameSgFgtPort2
  vpc_id      = local.idVpcNgfw

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

resource "alicloud_security_group_rule" "sgRuleFgtPrivateIngressALL" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.sgFgtPrivate.id
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "sgRuleFgtPrivateEgressALL" {
  type              = "egress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.sgFgtPrivate.id
  cidr_ip           = "0.0.0.0/0"
}



resource "alicloud_security_group" "sgFgtHAMgmt" {
  name        = local.nameSgFgtPort3
  description = local.nameSgFgtPort3
  vpc_id      = local.idVpcNgfw

  tags = {
    Terraform = true
    Project   = var.ProjectName
  }
}

locals {
  sgFgtHaMgmt = {
    icmp = {
      description = "ICMP"
      ip_protocol = "icmp"
      port_range  = "-1/-1"
      cidr_ip     = "0.0.0.0/0"
    },
    ssh = {
      description = "SSH"
      ip_protocol = "tcp"
      port_range  = "22/22"
      cidr_ip     = "0.0.0.0/0"
    },
    fgthttps = {
      description = "FGTHTTPS"
      ip_protocol = "tcp"
      port_range  = "${var.portFgtHttps}/${var.portFgtHttps}"
      cidr_ip     = "0.0.0.0/0"
    }
  }
}

resource "alicloud_security_group_rule" "sgRuleFgtHaMgmtIngress" {
  for_each = local.sgFgtHaMgmt

  type              = "ingress"
  policy            = "accept"
  nic_type          = "intranet"
  description       = lookup(each.value, "description", null)
  ip_protocol       = lookup(each.value, "ip_protocol", null)
  cidr_ip           = lookup(each.value, "cidr_ip", null)
  port_range        = lookup(each.value, "port_range", null)
  security_group_id = alicloud_security_group.sgFgtHAMgmt.id
}
