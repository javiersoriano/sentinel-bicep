param friendlyName string
param APIRootUrl string
param collectionId string
param userName string
param password string
param workspaceName string

@allowed([
  'OnceAMinute'
  'OnceAnHour'
  'OnceADay'
])
param pollingFrequency string = 'OnceAnHour'
param tenantId string = tenant().tenantId
param taxiiLookbackPeriod string = '1970-01-01T00:00:00.000Z'

var name = uniqueString(friendlyName)

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: workspaceName  
}

resource Taxii  'Microsoft.SecurityInsights/dataConnectors@2019-01-01-preview' = {
  scope: workspace 
  name: name
  kind: 'ThreatIntelligenceTaxii'
    properties: {
    collectionId: collectionId
    dataTypes: {
      taxiiClient: {
        state: 'enabled'
      }
    }
    friendlyName: friendlyName
    password: password
    pollingFrequency: pollingFrequency
    taxiiLookbackPeriod: taxiiLookbackPeriod
    taxiiServer: APIRootUrl
    tenantId: tenantId
    userName: userName
    workspaceId: workspace.id
  }
}

