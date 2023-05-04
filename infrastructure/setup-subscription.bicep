targetScope = 'subscription' //targeting the subscription so that we can create the resource group

@description('Type of environment.  Usually qa, uat, stg, prd, etc.')
param environment string

@description('The azure datacenter location (i.e. westus2).  Can be found with Azure CLI `az account list-locations -o table`.')
param location string = deployment().location

@description('The root of the resource group name.  This will have the environment appended to it.')
param resourceGroupNameBase string = 'wif-blog-aaes-'

var env = toLower(environment)

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${resourceGroupNameBase}${env}'
  location: location
}

module resourceGroupModule 'setup-resource-group.bicep' = {
  scope: resourceGroup
  name: 'setupResourceGroup'
  params: {
    environment: environment
    location: location
  }
}

output resourceGroupName string = resourceGroup.name
output staticWebsiteName string = resourceGroupModule.outputs.staticWebsiteName
output functionAppName string = resourceGroupModule.outputs.functionAppName
output functionAppUrl string = resourceGroupModule.outputs.functionAppUrl
