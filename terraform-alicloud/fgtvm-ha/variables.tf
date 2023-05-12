variable "ProjectName" { type = string }
variable "CompanyName" { type = string }

#################### INPUT VARIABLES ####################
variable "paramVpcNgfwId" {
  type    = string
  default = ""
}

variable "paramEipFgtCluster" {
  type    = string
  default = ""
}

variable "paramEipFgtMgmt1" {
  type    = string
  default = ""
}

variable "paramEipFgtMgmt2" {
  type    = string
  default = ""
}

#################### VPC ####################
variable "regionName" { type = string }
variable "azList" {
  type    = list(string)
  default = [""]
}

variable "nameVpcNgfw" { type = string }
variable "cidrVpcNgfw" {
  type = string
  validation {
    condition     = can(cidrsubnet(var.cidrVpcNgfw, 0, 0))
    error_message = "MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

#################### Subnets ####################
variable "cidrSubnetFgtPort1" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetFgtPort1 : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetFgtPort2" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetFgtPort2 : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetFgtPort3" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetFgtPort3 : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

variable "cidrSubnetFgtPort4" {
  type = list(string)
  validation {
    condition = alltrue([
      for cidr in var.cidrSubnetFgtPort4 : can(cidrsubnet(cidr, 0, 0))
    ])
    error_message = "ALL MUST BE IN COMPLIANCE WITH CIDR NOTATION!!!"
  }
}

#################### FortiGate ####################
variable "instanceTypeFgtFixed" { type = string }

variable "amiFgtBYOL64" { # FGT AliCloud (BYOL) - 6.4.5, cn-guangzhou is not available
  type = map(any)
  default = {
    cn-beijing     = "m-2zec5gpamoc7qaxzrx8x"
    cn-qingdao     = "m-m5ehlb1cpce22j0kyx1n"
    cn-zhangjiakou = "m-8vbcna7q8l6358yrsger"
    cn-huhehaote   = "m-hp3axqqvvr1s5dmtnxb1"
    cn-hangzhou    = "m-bp1bvdqhwetqmleaftfd"
    cn-shanghai    = "m-uf6cir5blv91vxt767p6"
    cn-shenzhen    = "m-wz92vsyvci6bm5pvmc3d"
    cn-heyuan      = "m-f8zffftdq6fymo9jbe3z"
    cn-chengdu     = "m-2vc5sn5ijz2ig88eyi52"
    cn-hongkong    = "m-j6c34y880spxo829x00e"
    ap-southeast-1 = "m-t4n8sc5yn5rwfzq4yqul"
    ap-southeast-2 = "m-p0w3o3anhh0qmab5jrug"
    ap-southeast-3 = "m-8psdkppcbb4ixmd7jylx"
    ap-southeast-5 = "m-k1a7crj6n4quw4jzlhiy"
    ap-northeast-1 = "m-6we9nwgq2cei4snuac6z"
    us-west-1      = "m-rj956dl5fwiwdiifk1wp"
    us-east-1      = "m-0xi6ede2a25ip585xt62"
    eu-central-1   = "m-gw84w9kn647ybzw8at2d"
    eu-west-1      = "m-d7o00pz6jt4s9omqpnbq"
    me-east-1      = "m-eb3bnvzgoxej3fkv9ndd"
    ap-south-1     = "m-a2d3nkfid1a2h3wcmg8a"
  }
}


variable "amiFgtBYOL70" { # FOS-7.0.8
  type = map(any)
  default = {
    cn-beijing     = "m-2ze7c3ow8glgvnb9r6su"
    cn-qingdao     = "m-m5e0wjym18t87mwq8mij"
    cn-zhangjiakou = "m-8vb733jos1zwkc2w3l2t"
    cn-huhehaote   = "m-hp30ofk1ij7glyx3sho1"
    cn-hangzhou    = "m-bp106q966nz056oi0sau"
    cn-shanghai    = "m-uf6guxuyl6z6kluwcas9"
    cn-shenzhen    = "m-wz9hajh4lzcynut9nklm"
    cn-heyuan      = "m-f8z1yo739z9yxo55dy7q"
    cn-chengdu     = "m-2vcbbgfpfl5jiqe3hzdk"
    cn-hongkong    = "m-j6c41val1n065dv3g9ky"
    ap-southeast-1 = "m-t4ngylld7yo49irasyuf"
    ap-southeast-2 = "m-p0wgg913jke2sbn4zhpd"
    ap-southeast-3 = "m-8psauaxdqaz81tmwf6ui"
    ap-southeast-5 = "m-k1a2zw0o19dyt8ow0m5m"
    ap-northeast-1 = "m-6we1tt40qp4bscr8ckig"
    us-west-1      = "m-rj90r2pe51hc4q8gashy"
    us-east-1      = "m-0xi51ir1zn4ytzv8avb1"
    eu-central-1   = "m-gw8h70kvvafrmzm82jqj"
    eu-west-1      = "m-d7o2bn825whxf77kbau7"
    me-east-1      = "m-eb3j7r0dsl5jf4gxaaj3"
    ap-south-1     = "m-a2de0xd6s73fbolpcp9u"
  }
}


#################### FortiGate Configuration File Variables ####################
variable "portFgtHttps" {
  type = string
  validation {
    condition     = can(regex("^(?:0|[1-9]\\d{0,3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5])$", var.portFgtHttps))
    error_message = "VALUE MUST BE IN RANGE FROM 0 TO 65535"
  }
}

variable "licenseFiles" {
  type    = list(string)
  default = [""]
}
