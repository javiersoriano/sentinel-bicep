param workspaceName string
param connectorName string

var connectorId = uniqueString(connectorName)

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: workspaceName
}

resource M365D_Incident 'Microsoft.SecurityInsights/dataConnectors@2019-01-01-preview' = { 
  scope: workspace
  name: connectorId
  kind: 'MicrosoftThreatProtection'
  properties: {
    tenantId: subscription().tenantId
		dataTypes: {
      incidents: {
        state: 'enabled'
      }
		  alerts: {
        state: 'disabled'
      }
		}
		}
}

