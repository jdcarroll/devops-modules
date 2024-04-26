// param resourceGroupName string
// param dataFactoryName string
param location string = resourceGroup().location
param factoryName string = uniqueString(resourceGroup().id)
param vnetName string = 'adfVnet'
// param endpointName string = 'adfPrivateEndpoint'

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: location
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}

resource virtualNetwork 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  parent: dataFactory
  name: vnetName
  properties: {}
}

// resource privateEndpoint 'Microsoft.DataFactory/factories/managedVirtualNetworks/privateEndpoints@2018-06-01' = {
//   parent: virtualNetwork
//   name: '${endpointName}'
//   properties: {
//     privateLinkServiceConnection: {
//       privateLinkServiceId: dataFactory.id
//       privateLinkServiceConnectionState: {
//         status: 'Approved'
//         description: 'Auto-approved connection'
//       }
//     }
//     manualPrivateLinkServiceConnections: []
//   }
// }

output dataFactoryName string = dataFactory.name
output managedVnetName string = virtualNetwork.name
output privateEndpointName string = privateEndpoint.name
