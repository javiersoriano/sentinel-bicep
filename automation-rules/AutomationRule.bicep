param workspaceName string
param automationRuleName string
param analyticsRuleId string
param automationRulePlaybookName string

var automationRuleId = uniqueString(automationRuleName)

resource LogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: workspaceName
}

resource analyticsRule 'Microsoft.SecurityInsights/alertRules@2019-01-01-preview' existing = {
  scope: LogAnalyticsWorkspace
  name: analyticsRuleId
}

resource playbook 'Microsoft.Logic/workflows@2019-05-01' existing = {
  name: automationRulePlaybookName
}

resource automationRule 'Microsoft.SecurityInsights/automationRules@2019-01-01-preview' = {
  scope: LogAnalyticsWorkspace
  name: automationRuleId
  properties: {
    displayName: automationRuleName
    order: 1
    triggeringLogic: {
      triggersWhen: 'Created'
      triggersOn: 'Incidents'
      isEnabled: true
      conditions: [
        {
          conditionType: 'Property'
          conditionProperties: {
            propertyName: 'IncidentRelatedAnalyticRuleIds'
            operator: 'Contains'
            propertyValues: [
              analyticsRule.id
            ]
          }
        }
        {
          conditionType: 'Property'
          conditionProperties: {
            propertyName: 'IncidentSeverity'
            operator: 'Equals'
            propertyValues: [
              'High'
            ]
          }
        }
        {
          conditionType: 'Property'
          conditionProperties: {
            propertyName: 'IncidentTactics'
            operator: 'Contains'
            propertyValues: [
              'InitialAccess'
              'Execution'
            ]
          }
        }
        {
          conditionType: 'Property'
          conditionProperties: {
            propertyName: 'IncidentTitle'
            operator: 'Contains'
            propertyValues: [
              'urgent'
            ]
          }
        }
      ]
    }
    actions: [
      {
        order: 1
        actionType: 'RunPlaybook'
        actionConfiguration: {
          logicAppResourceId: playbook.id
          tenantId: subscription().tenantId
        }
      }
      {
        order: 2
        actionType: 'ModifyProperties'
        actionConfiguration: {
          status: 'Closed'
          classification: 'Undetermined'
          classificationReason: null
        }
      }
      {
        order: 3
        actionType: 'ModifyProperties'
        actionConfiguration: {
          labels: [
            {
              labelName: 'tag'
            }
          ]
        }
      }
    ]
  }
}
