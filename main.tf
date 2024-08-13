# Resources group
resource "azurerm_resource_group" "rg" {
  name     = "rg-dns"
  location = "australiaeast"

  lifecycle {
    ignore_changes = [tags]
  }
}

# Random id
resource "random_id" "ri" {
  byte_length = 8
}

resource "random_string" "random" {
  length  = 4
  special = false
}

# Network Security Group 
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${lower(random_id.ri.id)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsg-rule" {
  name                        = "nsg-${lower(random_id.ri.id)}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "3389"]
  source_address_prefix       = azurerm_subnet.bas.address_prefixes[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
