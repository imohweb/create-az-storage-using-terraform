terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
 
  subscription_id   = "18e1c185-7e26-4dac-8fac-a7298088ab0b"
  tenant_id         = "ca781c30-a391-4e6a-aca5-bcaf8e88f9d1"
  client_id         = "2b18afd9-1eda-43bd-9e8b-43ed6c567984"
  client_secret     = "RAM8Q~Hvrl8gFZ59zSwium0k6DAfOJSufR_yXbX_"

}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}
