param workspaceName string
param connectorName string

var connectorId = uniqueString(connectorName)

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: workspaceName
}

resource connector 'Microsoft.SecurityInsights/dataConnectors@2019-01-01-preview' = {
  scope: workspace
  name: connectorId
  kind: 'Dynamics365'
  properties: {
    tenantId: subscription().tenantId
    dataTypes: { 
      dynamics365CDSActivities: { 
          state: 'enabled' 
      } 
    }
  }
}
