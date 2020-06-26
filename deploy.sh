#!/bin/bash
echo "
##############################################################################################################
#
##############################################################################################################
"

# Stop running when command returns error
set -e

if [ -z "$DEPLOY_LOCATION" ]
then
    # Input location
    echo -n "Enter location (e.g. eastus2): "
    stty_orig=`stty -g` # save original terminal setting.
    read location         # read the location
    stty $stty_orig     # restore terminal setting.
    if [ -z "$location" ]
    then
        location="eastus2"
    fi
else
    location="$DEPLOY_LOCATION"
fi
export TF_VAR_LOCATION="$location"
echo ""
echo "--> Deployment in $location location ..."
echo ""

if [ -z "$DEPLOY_PREFIX" ]
then
    # Input prefix
    echo -n "Enter prefix: "
    stty_orig=`stty -g` # save original terminal setting.
    read prefix         # read the prefix
    stty $stty_orig     # restore terminal setting.
    if [ -z "$prefix" ]
    then
        prefix="FORTI"
    fi
else
    prefix="$DEPLOY_PREFIX"
fi
export TF_VAR_PREFIX="$prefix"
echo ""
echo "--> Using prefix $prefix for all resources ..."
echo ""
rg="$prefix-RG"

if [ -z "$DEPLOY_USERNAME" ]
then
    # Input username
    echo -n "Enter username: "
    stty_orig=`stty -g` # save original terminal setting.
    read USERNAME         # read the prefix
    stty $stty_orig     # restore terminal setting.
    if [ -z "$USERNAME" ]
    then
        USERNAME="azureuser"
    fi
else
    USERNAME="$DEPLOY_USERNAME"
fi
echo ""
echo "--> Using username '$USERNAME' ..."
echo ""

if [ -z "$DEPLOY_PASSWORD" ]
then
    # Input password
    echo -n "Enter password: "
    stty_orig=`stty -g` # save original terminal setting.
    stty -echo          # turn-off echoing.
    read PASSWORD         # read the password
    stty $stty_orig     # restore terminal setting.
    echo ""
else
    PASSWORD="$DEPLOY_PASSWORD"
    echo ""
    echo "--> Using password found in env variable DEPLOY_PASSWORD ..."
    echo ""
fi

PLAN="terraform.tfplan"

echo ""
echo "==> Starting Terraform deployment"
echo ""

echo ""
echo "==> Terraform init"
echo ""
terraform init

echo ""
echo "==> Terraform plan"
echo ""
terraform plan --out "$PLAN" \
               -var "USERNAME=$USERNAME" \
               -var "PASSWORD=$PASSWORD"

echo ""
echo "==> Terraform apply"
echo ""
terraform apply "$PLAN"
if [[ $? != 0 ]];
then
    echo "--> ERROR: Deployment failed ..."
    exit $rc;
fi

cd ../

AKS= "$PREFIX-aks1"

az aks get-credentials --name $AKS --resource-group $rg

# Required in chart (error seen with kubectl get events -w)
#kubectl create serviceaccount ttsa

helm upgrade --install tailwindtraders ./Deploy/helm/web -f ./Deploy/helm/gvalues.yaml -f ./Deploy/helm/values.b2c.yaml  --set ingress.hosts={$AKS}  --set ingress.protocol=http --set image.repository=jvh01/tailwindtraders-jvh --set image.tag=latest

echo "
##############################################################################################################
#
##############################################################################################################
 Deployment information:

##############################################################################################################
"
