#### Deploy NGFW in existing VPC
# terraform plan -out=tfplan -var "paramVpcNgfwId=vpc-049a1deda8161a407"
# cidrs and ipAddrs need change accordingly as well
#### END ####

#### Associate NGFW with existing EIPs
# terraform plan -out=tfplan -var "paramEipFgtCluster=eip-049a1deda8161a407" -var "paramEipFgtMgmt1=eip-049a1deda8161a407" -var "paramEipFgtMgmt2=eip-049a1deda8161a407"
# cidrs and ipAddrs need change accordingly as well
#### END ####


ProjectName = "fgtvm-ha"
CompanyName = "JTB"

#################### VPC ####################
regionName                = "cn-shanghai"

# Plese refer below for detail AliCloud region and availability zone.
# https://help.aliyun.com/document_detail/40654.html?spm=a2c4g.750001.0.i1
azList                    = ["b", "b"]
# azList                    = ["h", "h"]

nameVpcNgfw               = "VPC-SECURITY"
cidrVpcNgfw               = "10.42.0.0/16"

#################### Subnets ####################
cidrSubnetFgtPort1        = ["10.42.201.0/24"]
cidrSubnetFgtPort2        = ["10.42.202.0/24"]
cidrSubnetFgtPort3        = ["10.42.203.0/24"]
cidrSubnetFgtPort4        = ["10.42.204.0/24"]

#################### FortiGate ####################
instanceTypeFgtFixed      = "ecs.c6.large"

#################### FortiGate Configuration File Variables ####################
portFgtHttps          = "8443"
licenseFiles          = [ 
                          "FGVM02TM22017609-AWS.lic",
                          "FGVM02TM22017610-AWS.lic",
                        ]