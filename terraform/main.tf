terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

# ---- Configurable variables (edit if needed) ----
locals {
  prefix   = "benetta"            # change to your prefix
  location = "centralindia"            # or "centralindia"/"southindia"
  rg_name  = "${local.prefix}-rg"
  acr_name = "myacrbenetta1086"      # must be globally unique & lowercase
  aks_name = "${local.prefix}-aks"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
}

# Azure Container Registry (admin enabled for demo)
resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# AKS cluster with System Assigned identity
resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${local.prefix}-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
    project     = "employee-mgmt-devops"
  }
}
