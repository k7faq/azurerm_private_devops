terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.98"
    }
  }
  # backend "azurerm" {}
  required_version = "~> 1.1.8"
}

provider "azurerm" {
  subscription_id = "d49d3e29-9064-4abd-9e4e-0d0fff4d6ba5"
  features {}
}
