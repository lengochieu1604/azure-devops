#RESOURCE LINUX & CENTOS
variable "var_resource_group" {}
variable "var_location" {}
variable "var_app_network" {}
variable "var_SubnetA" {}
variable "var_app_interface" {}
variable "var_address_space" {}

#VM LINUX
variable "var_linuxvm" {}
variable "var_user_linux_vm" {}
variable "var_pass_linux_vm" {}

#VM CENTOS
variable "var_centosvm" {}
variable "var_user_centos_vm" {}
variable "var_pass_centos_vm" {}

#RESOURCE JENKINS
variable "var_rg_jenkins" {}
variable "var_location_jenkins" {}
variable "var_vn_jenkins" {}
variable "var_sn_jenkins" {}
variable "var_nic_jenkins" {}
variable "var_address_space_jenkins" {}

#VM LINUX
variable "var_jenkinsvm" {}
variable "var_user_jenkins_vm" {}
variable "var_pass_jenkins_vm" {}

#REMOTE EXEC
variable "var_root_user" {}
variable "var_root_password" {}
variable "var_root_host" {}

#AKS & ACR#
variable "var_resource_group_aks" {}
variable "var_location_aks" {}
variable "var_acr" {}
variable "var_aks" {}
variable "var_role_aks" {}

#POSTGRES DATABASE
variable "var_resource_group_psql" {}
variable "var_location_psql" {}
variable "var_psql_server" {}
variable "var_user_psql" {}
variable "var_pass_psql" {}
variable "var_psql_db" {} 