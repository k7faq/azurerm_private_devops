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
  subscription_id = "< your subscription uuid here>"
  features {}
}
