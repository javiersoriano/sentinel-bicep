param workspaceName string
param connectorName string

var connectorId = uniqueString(connectorName)

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: workspaceName
}

resource Office365 'Microsoft.SecurityInsights/dataConnectors@2019-01-01-preview' = {
  scope: workspace
  name: connectorId
  kind: 'Office365'
  properties: {
    tenantId: subscription().tenantId
		dataTypes: {
      sharePoint: {
        state: 'enabled'
      }
		  exchange: {
        state: 'enabled'
      }
		  teams: {
        state:'enabled'
      }
		}
		}
}


