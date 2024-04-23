param appName string
param location string = resourceGroup().location
param appServicePlanSku string = 'Y1'
param vnetResourceId string
param subnetResourceId string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appName
  location: location
  sku: {
    name: appServicePlanSku
  }
  kind: 'functionapp'
  properties: {
    reserved: false
  }
}

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${applicationInsights.properties.InstrumentationKey}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
}

resource functionAppVnetIntegration 'Microsoft.Web/sites/virtualNetworkConnections@2020-06-01' = {
  parent: functionApp
  name: 'integration'
  properties: {
    vnetResourceId: vnetResourceId
    subnetResourceId: subnetResourceId

  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${appName}-ai'
  location: 'eastus' // Ensure Application Insights is supported in the region
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}
