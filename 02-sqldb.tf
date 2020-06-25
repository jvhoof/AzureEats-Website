resource "azurerm_sql_server" "sqlserver" {
  name                         = lower("${var.PREFIX}-srv")
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.LOCATION
  version                      = "12.0"
  administrator_login          = var.USERNAME
  administrator_login_password = var.PASSWORD

  tags = {
    environment = "production"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = lower("${var.PREFIX}storage")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "sqldatabase" {
  name                = "${var.PREFIX}-DB"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.LOCATION
  server_name         = azurerm_sql_server.sqlserver.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sa.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sa.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
}

# Allow Azure services to acccess the Azure SQL DB
resource "azurerm_sql_firewall_rule" "sqlfirewall" {
    name                = "${var.prefix}-sqlfirewall"
    resource_group_name = azurerm_resource_group.rg.name
    server_name         = azurerm_sql_server.sqlserver.name
    start_ip_address    = "0.0.0.0"
    end_ip_address      = "0.0.0.0"
}
