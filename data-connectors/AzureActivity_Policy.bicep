targetScope=  'subscription'

@description('Provide the resourceId to your Log Analytics workspace that will receive the Azure Activity logs. Example: /subscriptions/4b9e8510-67ab-4e9a-95a9-e2f1e570ea9c/resourceGroups/insights-integration/providers/Microsoft.OperationalInsights/workspaces/viruela2')
param logAnalyticsResourceId string

param SubscriptionID string = subscription().id
param ManagedIdentityLocation string

param policyAssignmentName string = 'Configure Azure Activity logs to stream to specified Log Analytics workspace'
param policyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
param AssignmentName string = newGuid()
param roleAssignmentMonitoringContributorName string = newGuid()
param roleAssignmentLogAnalyticsContributorName string = newGuid()
param remediationName string = newGuid()


resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
   name: AssignmentName
  location: ManagedIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: policyAssignmentName
    description: ''
    enforcementMode: 'Default'
    metadata: {
      source: ''
      version: '0.1.0'
      assignedBy: ''
      parameterScopes: {
        logAnalytics: substring(logAnalyticsResourceId,0, indexOf(logAnalyticsResourceId,'/resourcegroups')-1)
      }
    }
    policyDefinitionId: policyDefinitionID
    scope: '/subscriptions/${SubscriptionID}'
    notScopes:[]
    parameters: {
      logAnalytics: {
        value: logAnalyticsResourceId
      }      
    }
    nonComplianceMessages: []
  }
}

resource roleAssignmentMonitoringContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleAssignmentMonitoringContributorName
  scope: subscription()
  properties: {
    principalId: policyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'    
  
  }
}

resource roleAssignmentLogAnalyticsContributor 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleAssignmentLogAnalyticsContributorName
  scope: subscription()
  properties: {
    principalId: policyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'   
   
  }
}

resource remediation 'Microsoft.PolicyInsights/remediations@2019-07-01' = {
  name: remediationName
  properties: {    
    policyAssignmentId: policyAssignment.id  
    resourceDiscoveryMode: 'ReEvaluateCompliance'
  }
}

  
