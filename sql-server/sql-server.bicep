param sqlServerName string
param location string = resourceGroup().location
param administratorLogin string

@secure()
param administratorLoginPassword string

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    publicNetworkAccess: 'Enabled'
    minimalTlsVersion: '1.2'
  }
}

output sqlServerName string = sqlServer.name
output sqlServerFullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName
