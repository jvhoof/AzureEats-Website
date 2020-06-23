resource "azurerm_resource_group" "rg" {
  name     = "${var.PREFIX}-RG"
  location = var.LOCATION
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.PREFIX}-PLAN"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2"
    "ApiUrl"                       = ""
    "ApiUrlShoppingCart"           = ""
    "MongoConnectionString"        = ""
    "SqlConnectionString"          = ""
    "productImagesUrl"             = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
    "Personalizer_ApiKey"          = ""
    "Personalizer_Endpoint"        = ""
  }
}

resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = <<EOT
    az webapp deployment source config --resource-group "${azurerm_resource_group.rg.name}" --branch "${var.BRANCH}" --manual-integration --name ${azurerm_app_service.service.name} --repo-url "${var.REPOURL}"
    EOT
  }

  depends_on = [
    azurerm_app_service.service
  ]
}
