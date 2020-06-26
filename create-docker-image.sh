
az acr create --resource-group "jvh01-RG" --name "jvh01" --sku Basic

cd Source/Tailwind.Traders.Web

docker build -t tailwindtradars-jvh .

az acr login --name jvh01

docker tag tailwindtradars-jvh jvh01.azurecr.io/tailwindtraders-jvh

docker push jvh01.azurecr.io/tailwindtraders-jvh

docker pull jvh01.azurecr.io/tailwindtraders-jvh