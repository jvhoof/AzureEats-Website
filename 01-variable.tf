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

variable "BRANCH" {
  default = "master"
}

variable "REPOURL" {
  default = "https://github.com/jvhoof/AzureEats-Website"
}

##############################################################################################################
# Terraform version
##############################################################################################################
terraform {
  required_version = ">= 0.12"
}

##############################################################################################################
# Terraform Microsoft Azure Provider
##############################################################################################################
provider "azurerm" {
  version         = ">= 2.0.0"

  features {}
}