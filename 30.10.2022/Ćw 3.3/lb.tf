resource "azurerm_lb" "lb" {
  name                = "lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name
  
sku = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public-ip.id
   
  }
}

resource "azurerm_public_ip" "public-ip" {
  name                = "public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-prolab-rg[0].name
  allocation_method   = "Static"
  sku = "Standard"
}


resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "probe"
  port            = 80
  protocol ="Http"
  interval_in_seconds = 5
  request_path = "/"
  
}

resource "azurerm_lb_backend_address_pool" "address-pool" {
  name            = "address-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool_address" "pool-address1" {
  name                                = "pool-address1"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.address-pool.id
  #backend_address_ip_configuration_id = azurerm_lb.lb.frontend_ip_configuration[0].id
  ip_address              = "10.100.0.4"
   virtual_network_id = azurerm_virtual_network.vnet-dev-10-100-0-0--16.id
}

resource "azurerm_lb_backend_address_pool_address" "pool-address2" {
  name                                = "pool-address2"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.address-pool.id
  #backend_address_ip_configuration_id = azurerm_lb.lb.frontend_ip_configuration[0].id
  ip_address              = "10.100.0.5"
   virtual_network_id = azurerm_virtual_network.vnet-dev-10-100-0-0--16.id
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.address-pool.id]
  probe_id = azurerm_lb_probe.probe.id
   disable_outbound_snat = true
}

resource "azurerm_lb_nat_rule" "nat-rule" {
  resource_group_name            = azurerm_resource_group.dev-prolab-rg[0].name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "nat-rule"
  protocol                       = "Tcp"

  backend_port                   = 22
   frontend_port_start            = 22
  frontend_port_end            = 22
  
  backend_address_pool_id        = azurerm_lb_backend_address_pool.address-pool.id
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  
}

resource "azurerm_lb_outbound_rule" "out-rule" {
  name                    = "out-rule"
  loadbalancer_id         = azurerm_lb.lb.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.address-pool.id
allocated_outbound_ports = 0
  frontend_ip_configuration {
    name = "PublicIPAddress"
    
  }
}