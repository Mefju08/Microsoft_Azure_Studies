resource "azurerm_availability_set" "as-01"{
    name = "as-01"
    location = azurerm_resource_group.dev-prolab-rg[0].location
    resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name
    managed = true
    platform_fault_domain_count = 2
}


resource "azurerm_network_interface" "VM-WFE01-DEV-NIC" {
  name                = "VM-WFE01-DEV-NIC"
  location            = azurerm_resource_group.dev-prolab-rg[0].location
  resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name

  ip_configuration {
    name                          = "VM-WFE01-DEV-NIC-CONFIG"
    subnet_id                     = azurerm_subnet.subnet-frontend[0].id
    private_ip_address_allocation = "Dynamic"
    
  }

  tags                = {      
        "Project"     = "DEV"
        "Network"     = "DEV"
    }
}

resource "azurerm_linux_virtual_machine" "VM-WFE01-DEV" {
    availability_set_id = azurerm_availability_set.as-01.id
    name                            = "VM-WFE01-DEV"
    computer_name                   = "VM-WFE01-DEV"
    location            = azurerm_resource_group.dev-prolab-rg[0].location
    resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name
    size                            = "Standard_DS1_v2"
    
    disable_password_authentication = false
    admin_username                  = var.default-admin-username
    admin_password                  = var.default-admin-pass

    network_interface_ids = [
        azurerm_network_interface.VM-WFE01-DEV-NIC.id,
    ]

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
        name                 = "VM-WFE01-DEV-OS"
        
    }

    source_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
}




resource "azurerm_network_interface" "VM-WFE02-DEV-NIC" {
  name                = "VM-WFE02-DEV-NIC"
  location            = azurerm_resource_group.dev-prolab-rg[0].location
  resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name

  ip_configuration {
    name                          = "VM-WFE02-DEV-NIC-CONFIG"
    subnet_id                     = azurerm_subnet.subnet-frontend[0].id
    private_ip_address_allocation = "Dynamic"
    
  }

  tags                = {      
        "Project"     = "DEV"
        "Network"     = "DEV"
    }
}

resource "azurerm_linux_virtual_machine" "VM-WFE02-DEV" {
    availability_set_id = azurerm_availability_set.as-01.id
    name                            = "VM-WFE02-DEV"
    computer_name                   = "VM-WFE02-DEV"
    location            = azurerm_resource_group.dev-prolab-rg[0].location
    resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name
    size                            = "Standard_DS1_v2"
    
    disable_password_authentication = false
    admin_username                  = var.default-admin-username
    admin_password                  = var.default-admin-pass

    network_interface_ids = [
        azurerm_network_interface.VM-WFE02-DEV-NIC.id,
    ]

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
        name                 = "VM-WFE02-DEV-OS"
        
    }

    source_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
}

resource "azurerm_virtual_machine_extension" "enable-apache-01" {
  name                 = "enable-apache-01"
  virtual_machine_id   = azurerm_linux_virtual_machine.VM-WFE01-DEV.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": [
        "https://raw.githubusercontent.com/mifurm/AZNetWorkshop/main/DEV/install-apache-vm01.sh"
        ],
        "commandToExecute": "bash install-apache-vm01.sh"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "enable-apache-02" {
  name                 = "enable-apache-02"
  virtual_machine_id   = azurerm_linux_virtual_machine.VM-WFE02-DEV.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": [
        "https://raw.githubusercontent.com/mifurm/AZNetWorkshop/main/DEV/install-apache-vm02.sh"
        ],
        "commandToExecute": "bash install-apache-vm02.sh"
    }
SETTINGS
}
