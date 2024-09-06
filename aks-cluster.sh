# Get the list of subscriptions
subscriptions=$(az account list --output tsv --query '[].id')

# Iterate through each subscription
for subscription in $subscriptions; do
  echo "Processing subscription: $subscription"

  # Set the active subscription
  az account set --subscription "$subscription"

  # Get the list of AKS clusters in the current subscription
  clusters=$(az aks list --output tsv --query '[].name')

  # Iterate through each AKS cluster
  for cluster in $clusters; do
    echo "Updating kubeconfig for cluster: $cluster"

    # Get the resource group name for the current cluster
    resource_group=$(az aks list --output tsv --query "[?name=='$cluster'].resourceGroup")

    # Update the kubeconfig for the current cluster
    az aks get-credentials --resource-group "$resource_group" --name "$cluster" --overwrite-existing

    echo "Kubeconfig updated for cluster: $cluster"
  done
done

echo "Kubeconfig update completed for all subscriptions and clusters."
