resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
  name                                       = "rslv-forwarding-ruleset"
  resource_group_name                        = azurerm_resource_group.rg.name
  location                                   = azurerm_resource_group.rg.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.hub_private_dns_resolver_outbound.id]
}


resource "azurerm_private_dns_resolver_forwarding_rule" "this" {
  name                      = "rslv-forwarding-rules" # 
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  domain_name               = "corp.internal." # Domain name supports 2-34 lables and must end with a dot (period) for example corp.mycompany.com. has three lables.
  enabled                   = true
  target_dns_servers {
    ip_address = "192.168.1.53"
    port       = 53
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "shared" {
  name                      = "vlink-rslv-forwarding-rules-shared"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  virtual_network_id        = azurerm_virtual_network.shared.id
}

resource "azurerm_private_dns_resolver_virtual_network_link" "prd" {
  name                      = "vlink-rslv-forwarding-rules-prd"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  virtual_network_id        = azurerm_virtual_network.prd.id
}

resource "azurerm_private_dns_resolver_virtual_network_link" "npd" {
  name                      = "vlink-rslv-forwarding-rules-npd"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  virtual_network_id        = azurerm_virtual_network.npd.id
}
