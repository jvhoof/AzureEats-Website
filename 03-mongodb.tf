resource "azurerm_container_group" "aci" {
  name                = "${var.PREFIX}-ACI"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  dns_name_label      = lower("${var.PREFIX}-aci")
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mongo:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
     port     = 27017
      protocol = "TCP"
    }

    environment_variables = {
        MONGO_INITDB_ROOT_USERNAME = var.USERNAME
        MONGO_INITDB_ROOT_PASSWORD = var.PASSWORD
    }
  }
}
