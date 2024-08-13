# create storage account with blob storage
resource "azurerm_storage_account" "storage_account" {
  name                            = "st${lower(random_string.random.id)}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
}

resource "azurerm_private_endpoint" "pe_storage_account" {
  name                = "st-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pl.id

  private_service_connection {
    name                           = "st-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "st-endpoint-connection"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_st.id]
  }

  depends_on = [
    azurerm_storage_account.storage_account
  ]
}

