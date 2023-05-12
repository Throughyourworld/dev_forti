# Fortinet-AliCloud

## NOTICES!!!
* FortiGate-VM automation is available for `AliCloud.China` and `AliCloud.International` (with limited version).  
* For FortiGate version deatils, please refer to `Distribution Release Note`!!!  
* Pay-as-you-go (`PAYG`) is NOT available in all `AliCloud` regions, China or International.  
* `FortiGate v7.2` is NOT available in all `AliCloud` regions, China or International.  
* `FortiGate v6.4` is is not available in `cn-guangzhou` region.  

## 1. Authenticating with AliCloud
* SETTING Linux ENV  
```sh
export ALICLOUD_ACCESS_KEY="ak"
export ALICLOUD_SECRET_KEY="sk"
```

* SETTING Windows PowerShell ENV  
```sh
$env:ALICLOUD_ACCESS_KEY="ak"
$env:ALICLOUD_SECRET_KEY="sk"
```

* Failed to set up above environments, you will be prompted with the below error messages:  
```
│ Error: Invalid type option, support: access_key, sts, ecs_ram_role, ram_role_arn, rsa_key_pair
│
│   with provider["registry.terraform.io/aliyun/alicloud"],
│   on provider.tf line 1, in provider "alicloud":
│    1: provider "alicloud" {
```  

## 2. Terraform configuration
[Terraform Registry Documentation for AliCloud](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)

* init  
`terraform init`

* plan  
MODIFY AS NEEDED > `terraform.tfvars`  
`terraform plan -out=tfplan`

* apply  
`terraform apply "tfplan"`

* destroy  
`terraform destroy`



## APPENDIX
### Known Errors
* NO `license.lic` presence
```
Call to function "templatefile" failed: 6.alicloud_instance_fgt.conf:57,8-19: Invalid function argument; Invalid value for "path" parameter: no file exists at "license.lic"; this
│ function works only with files that are distributed as part of the configuration source code, so if this file will be created by a resource in this configuration you must instead obtain
│ this result from an attribute of that resource..
```


### IMPORT Existing Azure Resources
* import
```sh
terraform import -var-file="variables.tfvars" alicloud_vpc.vpcNgfw vpc-wz94p6jqq15zeg5f1ftyr
terraform import -var-file="variables.tfvars" alicloud_vswitch.vswPublic vsw-wz9mi1rk0inxakt0mrfn8
terraform import -var-file="variables.tfvars" alicloud_vswitch.vswPrivate vsw-wz9canwuy5r062r45nzsi
terraform import -var-file="variables.tfvars" alicloud_security_group.sgFgtPublic sg-wz901q3xtgn1n2f14abk
terraform import -var-file="variables.tfvars" alicloud_security_group.sgFgtPrivate sg-wz94yz92hbg84ki84ycs
terraform import -var-file="variables.tfvars" alicloud_ecs_network_interface.eniFgtPrivate eni-wz9fhlpwvi53uw4ztgog
terraform import -var-file="variables.tfvars" alicloud_eip_address.eipFgt eip-wz9lt4xzfqxzc97jhnp9d
terraform import -var-file="variables.tfvars" alicloud_instance.fgtStandalone i-wz91buom2mn35bchrzxy
terraform import -var-file="variables.tfvars" alicloud_route_table.rtbFgtPrivate vtb-wz98d3cbb4yjc6u08vpbo
```



### Terraformer CLI
[Terraformer for AliCloud](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/alicloud.md)   