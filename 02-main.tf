resource "azurerm_resource_group" "rg" {
  name     = "${var.PREFIX}-RG"
  location = var.LOCATION
}

resource "azurerm_container_registry" "acr" {
  name                     = "${var.PREFIX}ACR"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = true
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.PREFIX}-PLAN"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "service" {
  name                = "${var.PREFIX}-SERVICE"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
#    dotnet_framework_version = "v4.0"
#    scm_type                 = "LocalGit"
    linux_fx_version         = "DOCKER|msfttailwindtraders/tailwindtraderswebsite:latest"
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2"
    "ApiUrl" = ""
    "ApiUrlShoppingCart" = ""
    "MongoConnectionString" = ""
    "SqlConnectionString" = ""
    "productImagesUrl" = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
    "Personalizer_ApiKey" = ""
    "Personalizer_Endpoint" = ""
    "DOCKER_REGISTRY_SERVER_URL" = "https://index.docker.io"
  }
}
