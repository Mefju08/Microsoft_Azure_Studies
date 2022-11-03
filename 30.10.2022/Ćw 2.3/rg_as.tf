provider "azurerm" {
  subscription_id = "0b5dde22-ca78-46e1-a6e8-4106f4051d3a"
  features {}
}


resource "azurerm_resource_group" "example_resource_group" {
  name = "example_resource_group"
  location = "westeurope"
}

resource "azurerm_app_service_plan" "example_app_service_plan" {
  name                = "example_app_service_plan"
  location            = azurerm_resource_group.example_resource_group.location
  resource_group_name = azurerm_resource_group.example_resource_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "exampleappservice131231231" {
  name                = "exampleappservice131231231"
  location            = azurerm_resource_group.example_resource_group.location
  resource_group_name = azurerm_resource_group.example_resource_group.name
  app_service_plan_id = azurerm_app_service_plan.example_app_service_plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}