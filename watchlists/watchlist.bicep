param workspaceName string
param watchlistName string

resource LogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' existing = {
  name: workspaceName
}

resource watchlist 'Microsoft.SecurityInsights/watchlists@2021-03-01-preview' = {
  name: watchlistName
  scope: LogAnalyticsWorkspace
  properties: {
    displayName: watchlistName
    description: 'List of users and their locations'
    provider: 'Custom'
    source: 'Local file'
    itemsSearchKey: 'UserName'
    contentType: 'Text/Csv'
    numberOfLinesToSkip: 0
    rawContent: 'UserName, Country\nJohn, US\nAlex, FR\nCarlos, SP'
  }
}
