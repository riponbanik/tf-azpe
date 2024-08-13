resource "azurerm_public_ip" "pip" {
  name                = "pip-bas${lower(random_id.ri.id)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bas" {
  name                = "bas-bas${lower(random_id.ri.id)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  ip_connect_enabled  = true

  ip_configuration {
    name                 = "bas-configuration"
    subnet_id            = azurerm_subnet.bas.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}
