// param resourceGroupName string
param dataFactoryName string
param location string = resourceGroup().location

// Create Azure Data Factory
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}


// resource dataFactoryManagedVnet 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
//   parent: dataFactory
//   name: '${dataFactory.name}-default'
//   properties: {}
// }
