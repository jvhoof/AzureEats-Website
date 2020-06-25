##############################################################################################################
#
# Input variables
#
##############################################################################################################

# Prefix for all resources created for this deployment in Microsoft Azure
variable "PREFIX" {
  description = "Added name to each deployed resource"
}

variable "LOCATION" {
  description = "Azure region"
}

variable "USERNAME" {
}

variable "PASSWORD" {
}

variable "BRANCH" {
  default = "master"
}

variable "REPOURL" {
  default = "https://github.com/Terraform-On-Azure-Workshop/AzureEats-Website"
}

##############################################################################################################
# Azure Service Principal used by Terraform and local-exec
##############################################################################################################
variable "AZURE_CLIENT_ID" {
}
variable "AZURE_CLIENT_SECRET" {
}
variable "AZURE_SUBSCRIPTION_ID" {
}
variable "AZURE_TENANT_ID" {
}

##############################################################################################################
# Terraform version
##############################################################################################################
terraform {
  required_version = ">= 0.12"

  backend "azurerm" {
    resource_group_name   = "JVH01-RG"
    storage_account_name  = "jvh01state"
    container_name        = "state"
    key                   = "terraform.tfstate"
  }
}

##############################################################################################################
# Terraform Microsoft Azure Provider
##############################################################################################################
provider "azurerm" {
  version = ">= 2.0.0"
  subscription_id = var.AZURE_SUBSCRIPTION_ID
  client_id       = var.AZURE_CLIENT_ID
  client_secret   = var.AZURE_CLIENT_SECRET
  tenant_id       = var.AZURE_TENANT_ID

  features {}
}

##############################################################################################################
# Global resource group
##############################################################################################################
resource "azurerm_resource_group" "rg" {
  name     = "${var.PREFIX}-RG"
  location = var.LOCATION
}

