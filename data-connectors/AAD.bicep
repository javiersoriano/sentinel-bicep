
targetScope = 'tenant'

@description('Provide the resourceId to your Log Analytics workspace that will receive the AAD auding/sign-in logs. Example: /subscriptions/4b9e8510-67ab-4e9a-95a9-e2f1e570ea9c/resourceGroups/insights-integration/providers/Microsoft.OperationalInsights/workspaces/viruela2')
param logAnalyticsResourceId string
param connectorName string

var connectorId = uniqueString(connectorName)

resource AzureActiveDirectory 'microsoft.aadiam/diagnosticSettings@2017-04-01' = {
  name: connectorId
  properties: {
    workspaceId: logAnalyticsResourceId
    
    logs: [
      {
        category: 'AuditLogs'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
      {
        category: 'SignInLogs'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
      {
        category: 'NonInteractiveUserSignInLogs'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
        {
          category: 'ServicePrincipalSignInLogs'
          enabled: true
          retentionPolicy: {
            days: 0
            enabled: false
          }
      }
      {
        category: 'ManagedIdentitySignInLogs'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
      {
        category: 'ProvisioningLogs'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
      {
        category: 'ADFSSignInLogs'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
      {
        category: 'UserRiskEvents'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
      {
        category: 'RiskyUsers'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
    ]    
  }
}
