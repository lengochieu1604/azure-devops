# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.93.0"
    }
  }
}

###############################
#   RESOURCE LINUX & CENTOS   # 
###############################

# Configure the Microsoft Azure Provider
provider "azurerm" {  
  features {}
}

# Create resource group
resource "azurerm_resource_group" "app_grp" {
  name     = var.var_resource_group
  location = var.var_location
}

resource "azurerm_virtual_network" "app_network" {
  name                = var.var_app_network
  location            = var.var_location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = [element(var.var_address_space, 0)]
  depends_on = [
    azurerm_resource_group.app_grp
  ]
}

#Create  subnet
resource "azurerm_subnet" "SubnetA" {
  name                 = var.var_SubnetA
  resource_group_name  = azurerm_resource_group.app_grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = [element(var.var_address_space, 1)]
  depends_on = [
    azurerm_virtual_network.app_network
  ]
}

#Create public ip
resource "azurerm_public_ip" "app_pubic_ip" {
  count               = 2
  name                = "public_ip${count.index}"
  resource_group_name = azurerm_resource_group.app_grp.name
  location            = var.var_location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.app_grp
  ]
}

resource "azurerm_network_interface" "app_interface" {
  count               = 2
  name                = "app-interface-nic${count.index}"
  location            = var.var_location
  resource_group_name = azurerm_resource_group.app_grp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.app_pubic_ip.*.id, count.index)
  }

  depends_on = [
    azurerm_virtual_network.app_network,
    azurerm_public_ip.app_pubic_ip,
    azurerm_subnet.SubnetA
  ]
}
#VM LINUX TO INSTALL GITLAB
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = var.var_linuxvm
  resource_group_name = azurerm_resource_group.app_grp.name
  location            = var.var_location
  size                = "Standard_B4ms"

  admin_username = var.var_user_linux_vm
  admin_password = var.var_pass_linux_vm

  disable_password_authentication = false

  network_interface_ids = [element(azurerm_network_interface.app_interface.*.id, 0)]
  # azurerm_network_interface.app_interface.id,

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.app_interface
  ]
}
#VM CENTOS TO INSTALL AWX 
resource "azurerm_linux_virtual_machine" "centos_vm" {
  name                = var.var_centosvm
  resource_group_name = azurerm_resource_group.app_grp.name
  location            = var.var_location
  size                = "Standard_D2s_v3"

  admin_username = var.var_user_centos_vm
  admin_password = var.var_pass_centos_vm

  disable_password_authentication = false

  network_interface_ids = [element(azurerm_network_interface.app_interface.*.id, 1)]
  # azurerm_network_interface.app_interface.id,

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_5-gen2"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.app_interface
  ]
}

#----------------------------------------------------------------------#

###############################
# LINUX VM TO INSTALL JENKINS #
###############################

# Create resource group
resource "azurerm_resource_group" "rs_jenkins" {
  name     = var.var_rg_jenkins
  location = var.var_location_jenkins
}

resource "azurerm_virtual_network" "vn_jenkins" {
  name                = var.var_vn_jenkins
  location            = azurerm_resource_group.rs_jenkins.location
  resource_group_name = azurerm_resource_group.rs_jenkins.name
  address_space       = [element(var.var_address_space_jenkins, 0)]
  depends_on = [
    azurerm_resource_group.rs_jenkins
  ]
}

#Create subnet
resource "azurerm_subnet" "sn_jenkins" {
  name                 = var.var_sn_jenkins
  resource_group_name  = azurerm_resource_group.rs_jenkins.name
  virtual_network_name = azurerm_virtual_network.vn_jenkins.name
  address_prefixes     = [element(var.var_address_space_jenkins, 1)]
  depends_on = [
    azurerm_virtual_network.vn_jenkins
  ]
}

#Create public ip
resource "azurerm_public_ip" "public_ip_jenkins" {
  count               = 1
  name                = "public_ip_jenkins${count.index}"
  resource_group_name = azurerm_resource_group.rs_jenkins.name
  location            = azurerm_resource_group.rs_jenkins.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.rs_jenkins
  ]
}

resource "azurerm_network_interface" "nic_jenkins" {
  count               = 1
  name                = "app-interface-nic${count.index}"
  location            = azurerm_resource_group.rs_jenkins.location
  resource_group_name = azurerm_resource_group.rs_jenkins.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn_jenkins.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.public_ip_jenkins.*.id, count.index)
  }

  depends_on = [
    azurerm_virtual_network.vn_jenkins,
    azurerm_public_ip.public_ip_jenkins,
    azurerm_subnet.sn_jenkins
  ]
}

#VM LINUX TO INSTALL JENKINS
resource "azurerm_linux_virtual_machine" "vm_jenkins" {
  name                = var.var_jenkinsvm
  resource_group_name = azurerm_resource_group.rs_jenkins.name
  location            = azurerm_resource_group.rs_jenkins.location
  size                = "Standard_B2s"

  admin_username = var.var_user_jenkins_vm
  admin_password = var.var_pass_jenkins_vm

  disable_password_authentication = false

  network_interface_ids = [element(azurerm_network_interface.nic_jenkins.*.id, 0)]
  # azurerm_network_interface.app_interface.id,

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.nic_jenkins
  ]
}
#----------------------------------------------------------------------#

resource "null_resource" "install_and_run_ansible" {  
  # depends_on = [azurerm_linux_virtual_machine.linux_vm]
  connection {
      type     = "ssh"
      user     = var.var_user_centos_vm
      password = var.var_pass_centos_vm
      host     = azurerm_linux_virtual_machine.centos_vm.public_ip_address
  }

  provisioner "file" {  
    source      = "C:\\Users\\LeNgo\\assignment3\\install-awx.sh"
    destination = "/home/ac/install-awx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ac/install-awx.sh",
      "/home/ac/install-awx.sh",
      "git clone https://github.com/lengochieu1604/ansible-jenkins-gitlab",
      "cd ansible-jenkins-gitlab",
      "echo linux ansible_host=${azurerm_linux_virtual_machine.linux_vm.public_ip_address} ansible_connection=ssh ansible_user=${var.var_user_linux_vm} ansible_ssh_pass=${var.var_pass_linux_vm} > ./inventory",
      "ansible-playbook playbook.yml -i inventory", 


    ]
  }
  # provisioner "remote-exec" {
  #   inline = [
  #     "cd /home/ynu/Desktop/ansible-gitlab",
  #     "echo linux ansible_host=${azurerm_linux_virtual_machine.linux_vm.public_ip_address} ansible_connection=ssh ansible_user=${var.var_user_linux_vm} ansible_ssh_pass=${var.var_pass_linux_vm} > ./inventory",
  #     "ansible-playbook playbook.yml -i inventory", 
  #   ]
  # }
}

########################
#      AKS & ACR       #
########################
# azurerm_container_registry
# azurerm_kubernetes_cluster

resource "azurerm_resource_group" "aks_rg" {
  # count = 2
  # name = "app_rg${count.index}"
  # location = element(var.var_location,index)
  name     = var.var_resource_group_aks
  location = var.var_location_aks
}

resource "azurerm_container_registry" "acr" {
  name                = var.var_acr
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.var_aks
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_role_assignment" "aks_role" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = var.var_role_aks
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}


########################
#  POSTGRES DATABASE   #
########################
# azurerm_postgresql_database
# Manages a PostgreSQL Database within a PostgreSQL Server

resource "azurerm_resource_group" "example" {
  name     = var.var_resource_group_psql
  location = var.var_location_psql
}

resource "azurerm_postgresql_server" "example" {
  name                = var.var_psql_server
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku_name = "B_Gen5_2"
  # sku_name = "Standard_B1ms"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.var_user_psql
  administrator_login_password = var.var_pass_psql
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "example" {
  name                = var.var_psql_db
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.example.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}