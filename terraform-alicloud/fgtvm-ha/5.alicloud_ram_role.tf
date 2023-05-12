locals {
  nameIamRoleFgtHA = "FGT-HA-${substr(local.idVpcNgfw, -8, -1)}"
}



resource "alicloud_ram_role_policy_attachment" "attachSysRoleECS" {
  policy_name = "AliyunECSFullAccess"
  policy_type = "System"
  role_name   = alicloud_ram_role.roleFgtHa.name
}

resource "alicloud_ram_role_policy_attachment" "attachSysRoleVPC" {
  policy_name = "AliyunVPCFullAccess"
  policy_type = "System"
  role_name   = alicloud_ram_role.roleFgtHa.name
}

resource "alicloud_ram_role_policy_attachment" "attachSysRoleEIP" {
  policy_name = "AliyunEIPFullAccess"
  policy_type = "System"
  role_name   = alicloud_ram_role.roleFgtHa.name
}



resource "alicloud_ram_role" "roleFgtHa" {
  name        = local.nameIamRoleFgtHA
  document    = <<EOF
    {
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": [
              "ecs.aliyuncs.com"
            ]
          }
        }
      ],
      "Version": "1"
    }
    EOF
  description = "RAM ROLE FOR FORTIGATE HA"
  force       = true
}
