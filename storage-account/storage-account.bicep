param storageAccountName string
param location string = resourceGroup().location
param skuName string = 'Standard_LRS'
param accessTier string = 'Hot'
param kind string = 'StorageV2'
param keySource string = 'Microsoft.Storage'
param blob_enabled bool = false
param supportsHttpsTrafficOnly bool = false

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
}

output storageAccountId string = storageAccount.id
