output "app_service_url" {
  value = "${azurerm_app_service.service.default_site_hostname}"
}