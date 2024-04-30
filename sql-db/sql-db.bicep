param sqlServerName string
param databaseName string
param location string = resourceGroup().location
param skuName string = 'S0' // Default to S0. Change as needed.

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' existing = {
  name: sqlServerName
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648 // 2 GB, adjust as needed
  }
}

output connectionString string = 'Server=tcp:${sqlServerName}.database.windows.net,1433;Initial Catalog=${databaseName};Persist Security Info=False;User ID=<YourUsername>;Password=<YourPassword>;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
