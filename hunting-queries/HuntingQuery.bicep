param workspaceName string
param huntingQueryName string

var huntingQueryId = uniqueString(huntingQueryName)

resource LogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: workspaceName
}

resource huntingQuery 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
  name: '${workspaceName}/${huntingQueryId}'
  properties: {
    category: 'Hunting Queries'
    displayName: huntingQueryName
    query: ''
    tags: [
      {
        name: 'description'
        value: 'Demo'
      }
      {
        name: 'tactics'
        value: 'CommandAndControl, Collection'
      }
      {
        name: 'techniques'
        value: 'T1547,T1547.001'
      }
    ]
    etag: '*'
  }
}
