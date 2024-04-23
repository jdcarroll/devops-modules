# Azure Container Registry Bicep Module

This is the Module that can be used to deploy a container registry into Azure.

## Example Usage

```bicep
module testing_acr './modules/azure-container-registry/azure-container-registry.bicep' = {
  name: 'testing_acr'
  params: {
    acrName: 'testing_acr'
    location: newRG.location
    acrSku: 'Basic'
  } 
}

```

## Argument Reference

| Name              | Description                                     | Type   | Default                | Required |
|-------------------|-------------------------------------------------|:------:|:----------------------:|:--------:|
| acrName           | Name of the registry to be created              | STRING | acr<ResourceGroupId>   | No
| location          | What region is the acr being deployed in?       | STRING | resourceGroup.location | No
| acrSku            | Provide a tier of your Azure Container Registry.| STRING | Basic                  | No

## Attribute Reference

| Name        | Description                                     |
|-------------|-------------------------------------------------|
| loginServer | Output the login server property for later use.