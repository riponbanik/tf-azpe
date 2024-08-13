resource "azurerm_private_dns_zone" "private_dns_zone_st" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vlink-storage" {
  name                  = "vlink-storage"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_st.name
  virtual_network_id    = azurerm_virtual_network.shared.id
}
