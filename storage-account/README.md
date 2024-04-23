# Azure Storage Account Bicep Module

An Azure Storage Account is a service provided by Microsoft Azure that offers scalable cloud storage for data objects, files, disks, queues, and tables, supporting both high availability and data redundancy.

## Example Usage

```bicep
param deploymentName string = 'storageDeployment'
param location string = 'eastus'

module storageModule './modules/storageAccount.bicep' = {
  name: deploymentName
  params: {
    storageAccountName: 'myUniqueStorageAccountName'
    location: location
  }
}

output deployedStorageAccountId string = storageModule.outputs.storageAccountId

```

## Argument Reference

| Name                | Description                                | Type   | Default                    | Required |
|---------------------|--------------------------------------------|--------|----------------------------|----------|
| storageAccountName  | The name of the storage account.           | string | N/A                        | Yes      |
| location            | The geographic location of the deployment. | string | `resourceGroup().location` | No       |
| skuName             | The SKU name for the storage account.      | string | 'Standard_LRS'             | No       |


## Attribute Reference

| Name              | Description                                            | Type   |
|-------------------|--------------------------------------------------------|--------|
| storageAccountId  | The unique identifier of the deployed storage account. | string |
