###
### TODO: Setup Your provider
###
provider "azurerm" {
  subscription_id = "0b5dde22-ca78-46e1-a6e8-4106f4051d3a"
  features {}
}

#TODO
#terraform {
#  backend "azurerm" {
#    storage_account_name = "<ACCOUNT NAME>" 
#    container_name       = "<CONTAINER>" 
#    key                  = "cloudeng.shared.terraform.tfstate"  
#    access_key  = 
#  }
#}
