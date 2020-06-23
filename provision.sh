#!/bin/bash

# Variables passed from Terraform Local-Exec
while getopts a:c:p:r:s:t: option
do
    case "${option}"
    in
        s) SUBCRIPTIONID=${OPTARG};;
        t) TENANTID=${OPTARG};;
        c) CLIENTID=${OPTARG};;
        p) CLIENTSECRET=${OPTARG};;
        r) RESOURCEGROUPNAME=${OPTARG};;
        a) APPSERVICENAME=${OPTARG};;
    esac
done

echo "Updating $APPSERVICENAME in resource group $RESOURCEGROUPNAME ..."

# Local variables
BRANCH="master"
GITHUBURL="https://github.com/jvhoof/AzureEats-Website"

# Login to your Azure Subscription
az login --service-principal --tenant $TENANTID \
                             --username "$CLIENTID" \
                             --password "$CLIENTSECRET"

# Update your webapp with the location of the source code in GitHub
az webapp deployment source config --resource-group "$RESOURCEGROUPNAME" \
                                   --branch "$BRANCH" \
                                   --name "$APPSERVICENAME" \
                                   --repo-url "$GITHUBURL"