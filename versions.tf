terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.73"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.52"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.2"
    }

  }
  required_version = ">= 1.7.0"
}
