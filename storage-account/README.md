# Azure Storage Account Bicep Module

An Azure Storage Account is a service provided by Microsoft Azure that offers scalable cloud storage for data objects, files, disks, queues, and tables, supporting both high availability and data redundancy.

## Example Usage

```bicep
param deploymentName string = 'storageDeployment'
param location string = 'eastus'

module storageModule './modules/storage-account/storage-account.bicep' = {
  name: deploymentName
  params: {
    storageAccountName: 'myUniqueStorageAccountName'
    location string = resourceGroup().location
    skuName string = 'Standard_LRS'
    accessTier string = 'Hot'
    kind string = 'StorageV2'
    keySource string = 'Microsoft.Storage'
    blob_enabled bool = true
    supportsHttpsTrafficOnly bool = true
  }
}

output deployedStorageAccountId string = storageModule.outputs.storageAccountId

```

## Argument Reference

| Name                     | Description                                | Type   | Default                    | Required |
|--------------------------|--------------------------------------------|--------|----------------------------|----------|
| storageAccountName       | The name of the storage account.           | string | N/A                        | Yes      |
| location                 | The geographic location of the deployment. | string | `resourceGroup().location` | No       |
| skuName                  | The SKU name for the storage account.      | string | 'Standard_LRS'             | No       |
| accessTier               | The speed of access are you looking for.   | string | 'HOT'                      | No       |
| kind                     | The Type of Storage                        | string | 'StorageV2'                | No       |
| keySource                | The Source of Storage                      | string | 'Microsoft.Storage'        | No       |
| blob_enabled             | Do you want blob storage anabled?          | bool   | true                       | No       |
| supportsHttpsTrafficOnly | no http traffic                            | bool   | true                       | No       |

## Attribute Reference

| Name              | Description                                            | Type   |
|-------------------|--------------------------------------------------------|--------|
| storageAccountId  | The unique identifier of the deployed storage account. | string |
