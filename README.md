# Terraform on Azure Challenge

## Challenge 1

Run the below one liner on (Azure Cloud Shell)[https://shell.azure.com] or fork and use GitHub actions.

```
cd ~/clouddrive/ && wget -qO- https://github.com/jvhoof/AzureEats-Website/archive/master.zip | jar x && cd ~/clouddrive/AzureEats-Website/ && ./deploy.sh
```

GitHub Action runners need credentials to run inside your Azure Subscription. Create an Azure Service Principal and create a secret in GitHub called AZURE_CREDENTIALS with the format below with the values form the Azure Service Principal

```
{
    "clientId": "...",
    "clientSecret": "...",
    "subscriptionId": "...",
    "tenantId": "..."
  }
```
