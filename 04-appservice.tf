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
    always_on           = true
    default_documents   = [
      "Default.htm",
      "Default.html",
      "hostingstart.html"
    ]
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2"
    "ApiUrl"                       = "/api/v1"
    "ApiUrlShoppingCart"           = "/api/v1"
    "MongoConnectionString"        = "mongodb://${var.USERNAME}:${var.PASSWORD}@${azurerm_container_group.aci.fqdn}:27017"
    "SqlConnectionString"          = "Server=tcp:${azurerm_sql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.sqldatabase.name};Persist Security Info=False;User ID=${var.USERNAME};Password=${var.PASSWORD};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30"
    "productImagesUrl"             = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
    "Personalizer_ApiKey"          = ""
    "Personalizer_Endpoint"        = ""
  }
}

resource "null_resource" "deploy" {
  provisioner "local-exec" {
    command = <<EOT
    az webapp deployment source config --resource-group "${azurerm_resource_group.rg.name}" --branch "${var.BRANCH}" --manual-integration --name ${azurerm_app_service.service.name} --repo-url "${var.REPOURL}"
    EOT
  }

  depends_on = [
    azurerm_app_service.service
  ]
}