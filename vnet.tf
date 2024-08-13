# Shared Services - Virtual network
resource "azurerm_virtual_network" "shared" {
  name                = "vnet-shared"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}

# Private Endpoint Resolver Inbound Subnet
resource "azurerm_subnet" "dns_inbound" {
  name                 = "snet-inbound"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.shared.name
  address_prefixes     = ["10.0.0.0/27"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

}

# Private Endpoint Resolver Outbound Subnet
resource "azurerm_subnet" "dns_outbound" {
  name                 = "snet-outbound"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.shared.name
  address_prefixes     = ["10.0.0.32/27"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Private Endpoint Subnet
resource "azurerm_subnet" "pl" {
  name                 = "snet-pl"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.shared.name
  address_prefixes     = ["10.0.0.64/27"]
}

# Bastion Subnet
resource "azurerm_subnet" "bas" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.shared.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.0.96/27"]
}


# Production Workload - Vnet
resource "azurerm_virtual_network" "prd" {
  name                = "vnet-prod"
  address_space       = ["10.1.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "prd" {
  name                 = "snet-prod"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.prd.name
  address_prefixes     = ["10.1.0.0/27"]
}

# Non-Production Workload - Vnet
resource "azurerm_virtual_network" "npd" {
  name                = "vnet-npd"
  address_space       = ["10.2.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "npd" {
  name                 = "snet-npd"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.npd.name
  address_prefixes     = ["10.2.0.0/27"]
}


# Azure Virtual Network peering between Virtual Network Prod and Shared Services
resource "azurerm_virtual_network_peering" "peer_p2s" {
  name                         = "peer-vnet-prd-with-shared"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.prd.name
  remote_virtual_network_id    = azurerm_virtual_network.shared.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peer_s2p" {
  name                         = "peer-vnet-shared-with-prd"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.shared.name
  remote_virtual_network_id    = azurerm_virtual_network.prd.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Azure Virtual Network peering between Virtual Network Non-Prod and Prod
resource "azurerm_virtual_network_peering" "peer_n2s" {
  name                         = "peer-vnet-npd-with-shared"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.npd.name
  remote_virtual_network_id    = azurerm_virtual_network.shared.id
  allow_virtual_network_access = true
  depends_on                   = [azurerm_virtual_network_peering.peer_p2s]
}


resource "azurerm_virtual_network_peering" "peer_s2n" {
  name                         = "peer-vnet-shared-with-npd"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.shared.name
  remote_virtual_network_id    = azurerm_virtual_network.npd.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
