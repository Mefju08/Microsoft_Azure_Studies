provider "azurerm" {
  subscription_id = "0b5dde22-ca78-46e1-a6e8-4106f4051d3a"
  features {}
}


resource "azurerm_resource_group" "LoadBalancerRG" {
  name     = "LoadBalancerRG"
  location = "West Europe"
}

resource "azurerm_public_ip" "PublicIPForLB" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.LoadBalancerRG.location
  resource_group_name = azurerm_resource_group.LoadBalancerRG.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "TestLoadBalancer" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.LoadBalancerRG.location
  resource_group_name = azurerm_resource_group.LoadBalancerRG.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.PublicIPForLB.id
  }
}