param deploymentStage string
param applicationName string
param applicationId string
param businessUnit string
param location string
param tags object
@description('The name of the storage account to link to the data factory')
param stName string

param sqlServerName string
param sqlDbNames array

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: join(['adf', businessUnit, deploymentStage, applicationName, applicationId], '-')
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
    // userAssignedIdentities: {
    //   {customized property}: any()
    // }
  }
  properties: {
    // encryption: {
    //   identity: {
    //     userAssignedIdentity: 'string'
    //   }
    //   keyName: 'string'
    //   keyVersion: 'string'
    //   vaultBaseUrl: 'string'
    // }
    globalParameters: {
      // {customized property}: {
      //   type: 'string'
      //   value: any()
      // }
    }
    publicNetworkAccess: 'Disabled'
    // purviewConfiguration: {
    //   purviewResourceId: 'string'
    // }
    // repoConfiguration: {
    //   accountName: 'string'
    //   collaborationBranch: 'string'
    //   disablePublish: bool
    //   lastCommitId: 'string'
    //   repositoryName: 'string'
    //   rootFolder: 'string'
    //   type: 'string'
    //   // For remaining properties, see FactoryRepoConfiguration objects
    // }
  }
}

var managedVnetName = 'default'
var managedVnetRuntimeName = 'ManagedVnetIntegrationRuntime'

// Create managed virtual network and integration runtime
resource managedVirtualNetwork 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: managedVnetName
  parent: dataFactory
  properties: {}
}

resource managedIntegrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: managedVnetRuntimeName
  parent: dataFactory
  properties: {
    type: 'Managed'
    managedVirtualNetwork: {
      referenceName: managedVnetName
      type: 'ManagedVirtualNetworkReference'
    }
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
  }
  dependsOn: [
    managedVirtualNetwork
  ]
}

// Get existing storage account using stName
resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: stName
}

// Using sqlServerName parameter, get existing sql server
resource sqlServer 'Microsoft.Sql/servers@2014-04-01' existing = {
  name: sqlServerName
}

var linkedServicesList = concat(
  array({
    name: 'csv-storage'
    mpepName: storageAccount.name
    groupId: 'blob'
    privateLinkResourceId: storageAccount.id
    typeProperties: {
      serviceEndpoint: 'https://${storageAccount.name}.blob.core.windows.net'
      accountKind: 'StorageV2'
    }
    type: 'AzureBlobStorage'
  }),
  map(
    range(0, length(sqlDbNames)), i => {
      name: sqlDbNames[i]
      mpepName: sqlServer.name
      groupId: 'sqlServer'
      privateLinkResourceId: sqlServer.id
      typeProperties: {
        connectionString: 'Integrated Security=False;Encrypt=True;Connection Timeout=30;Data Source=${sqlServer.name}.database.windows.net;Initial Catalog=${sqlDbNames[i]}'
      }
      type: 'AzureSqlDatabase'
    }
  )
)

resource linkedServices 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = [
  for item in linkedServicesList: {
    parent: dataFactory
    name: item.name
    properties: {
      type: item.type
      typeProperties: item.typeProperties
      connectVia: {
        referenceName: managedIntegrationRuntime.name
        type: 'IntegrationRuntimeReference'
      }
    }
  }
]

resource managedPrivateEndpoints 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = [
  // Pluck out mpeps we have to create by finding unique combinations of privateLinkResourceId and groupId
  for item in items(reduce(map(linkedServicesList, i => { '${i.groupId}': { privateLinkResourceId: i.privateLinkResourceId, mpepName: i.mpepName }}), {}, (cur, next) => union(cur, next))) : {
    dependsOn: linkedServices
    name: item.value.mpepName
    parent: managedVirtualNetwork
    properties: {
      connectionState: {}
      fqdns: [
        //'string'
      ]
      groupId: item.key
      privateLinkResourceId: item.value.privateLinkResourceId
      // {customized property}: any()
    }
  }
]
