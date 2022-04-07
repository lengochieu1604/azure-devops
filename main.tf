module "virtualMachine_linux_win" {
  source = "./virtualMachine_linux_win" 
  
  #RESOURCE LINUX & CENTOS
  var_resource_group = "app-grp3"
  var_location       = "East Asia"
  var_app_network    = "app-network3"
  var_SubnetA        = "SubnetA3"
  var_app_interface  = "app-interface3"
  var_address_space  = ["10.0.0.0/16", "10.0.1.0/24"]

  #VM LINUX
  var_linuxvm       = "linuxvm3"
  var_user_linux_vm = "al"
  var_pass_linux_vm = "Azure@123"

  #VM CENTOS
  var_centosvm       = "centos3"
  var_user_centos_vm = "ac"
  var_pass_centos_vm = "Azure@123"

  #RESOURCE JENKINS
  var_rg_jenkins = "JENKINS-RS"
  var_location_jenkins       = "Korea Central"
  var_vn_jenkins    = "vn_jenkins"
  var_sn_jenkins         = "sn_jenkins"
  var_nic_jenkins  = "nic_jenkins"
  var_address_space_jenkins  = ["10.0.0.0/16", "10.0.1.0/24"]

  #VM LINUX
  var_jenkinsvm       = "jenkinsvm"
  var_user_jenkins_vm = "al"
  var_pass_jenkins_vm = "Azure@123"


  #REMOTE EXEC
  var_root_user     = "ynu"
  var_root_password = "adminubuntu"
  var_root_host     = "100.0.0.131"

  #AKS & ACR#
  var_resource_group_aks = "AKS-RG"
  var_location_aks       = "Australia East"
  var_acr                = "acrlengochieu"
  var_aks                = "myakslengochieu"
  var_role_aks           = "AcrPull"

  #POSTGRES DATABASE
  var_resource_group_psql = "DB-RG"
  var_location_psql       = "UAE North"
  var_psql_server         = "psqlserverlengochieu1356"
  var_user_psql           = "adminpsql"
  var_pass_psql           = "Azure@123"
  var_psql_db             = "psqldblengochieu1356" 

}


