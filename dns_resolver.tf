# Private DNS Resolver
resource "azurerm_private_dns_resolver" "hub_private_dns_resolver" {
  name                = "rslv-private-dns"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_network_id  = azurerm_virtual_network.shared.id
  lifecycle {
    ignore_changes = [tags]
  }
}


# Private DNS Resolver Inbound Endpoint
resource "azurerm_private_dns_resolver_inbound_endpoint" "hub_private_dns_resolver_inbound" {
  name                    = "rslv-inbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub_private_dns_resolver.id
  location                = azurerm_private_dns_resolver.hub_private_dns_resolver.location

  ip_configurations {
    private_ip_allocation_method = "Static"
    subnet_id                    = azurerm_subnet.dns_inbound.id
    private_ip_address           = "10.0.0.5"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}


# Private DNS Resolver Outbound Endpoint
resource "azurerm_private_dns_resolver_outbound_endpoint" "hub_private_dns_resolver_outbound" {
  name                    = "rslv-outbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub_private_dns_resolver.id
  location                = azurerm_private_dns_resolver.hub_private_dns_resolver.location
  subnet_id               = azurerm_subnet.dns_outbound.id

  lifecycle {
    ignore_changes = [tags]
  }
}
