param acrName string
param aksPrincipalId string

resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' existing = {
  name: acrName
}

resource AssignAcrPullToAks 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, acrName, aksPrincipalId, 'AssignAcrPullToAks')   // Use a consistent GUID on each run
  scope: acr
  properties: {
    description: 'Assign AcrPull role to AKS'
    principalId: aksPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // Role ID for AcrPull
  }
}

// Provide permissions for the identity performing the deployment to assign roles
resource roleAssignmentPermissions 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, 'RoleAssignmentPermissions')
  scope: subscription()
  properties: {
    principalId: aksPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Role ID for Owner
  }
}
