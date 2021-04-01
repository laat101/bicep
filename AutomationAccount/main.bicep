param location string = resourceGroup().location
param AutomationAccountName string = 'Automation'

resource AutomationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: '${AutomationAccountName}'
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource Az_Compute 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.Compute'
  dependsOn: [
    Az_Accounts
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Compute/4.10.0'
      version: '4.10.0'
    }
  }
}

resource Az_Network 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.Network'
  dependsOn: [
    Az_Accounts
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Network/4.7.0'
      version: '4.7.0'
    }
  }
}

resource Az_Accounts 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.Accounts'
  dependsOn: [
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Accounts/2.2.7'
      version: '2.2.7'
    }
  }
}

resource Az_Resources 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.Resources'
  dependsOn: [
    Az_Accounts
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Resources/3.4.0'
      version: '3.4.0'
    }
  }
}

resource Az_Storage 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.Storage'
  dependsOn: [
    Az_Accounts
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Storage/3.5.0'
      version: '3.5.0'
    }
  }
}

resource Az_DesktopVirtualization 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.DesktopVirtualization'
  dependsOn: [
    Az_Accounts
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.DesktopVirtualization/2.1.1'
      version: '2.1.1'
    }
  }
}

resource Az_Profile 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.Profile'
  dependsOn: [
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Profile/0.7.0'
      version: '0.7.0'
    }
  }
}

resource Az_Automation 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.Automation'
  dependsOn: [
    Az_Accounts
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Automation/1.5.2'
      version: '1.5.2'
    }
  }
}

resource Az_Insights 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.Insights'
  dependsOn: [
    Az_Profile
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.Insights/0.7.0'
      version: '0.7.0'
    }
  }
}

resource Az_ResourceGraph 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
  name: '${AutomationAccountName}/Az.ResourceGraph'
  dependsOn: [
    Az_Accounts
    AutomationAccount
  ]
  properties: {
    contentLink: {
      uri: 'https://www.powershellgallery.com/api/v2/package/Az.ResourceGraph/0.8.0'
      version: '0.8.0'
    }
  }
}
