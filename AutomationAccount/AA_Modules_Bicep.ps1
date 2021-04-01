$ModulesFile = Read-Host "Enter input file location (fullpath)"
$BicepOutputfile = Read-Host "Enter BICEP output (fullpath)"

try {
    $Modules = Get-content  $ModulesFile
}
catch {
    Throw "Unable to open Modules file."
}

$GalleryModules = @()
$GalleryModules = $Modules | ForEach-Object -Parallel {
    try {
        Find-Module $_ -Repository PSGallery
    }
    catch {
        throw "Unable load module information from the PowerShell Gallery module: $_"
    }
}

$BicepModules = @()
$ChildModules = @()
foreach ($Mod in $GalleryModules | Where-Object { $Modules -contains $_.Name } ) {
    $Props = @{
        ModuleName     = $Mod.Name
        Version        = $Mod.Version
        Package        = "https://www.powershellgallery.com/api/v2/package/{0}/{1}" -f $Mod.Name, $Mod.Version
        BicepDependsOn = (@(foreach ($Dependency in $Mod.Dependencies) { $Dependency.name.Replace('.', '_') }) + "`tAutomationAccount" | out-string) + "`t"
    }
    $BicepModules += $props
    foreach ($Dependency in $Mod.Dependencies) {
        $ChildModules += @{
            Parent  = $Mod.Name
            Name    = $Dependency.Name
            Version = if ($Dependency.MinimumVersion) { $Dependency.MinimumVersion } elseif ($Dependency.RequiredVersion) { $Dependency.RequiredVersion } elseif ($Dependency.MaximumVersion) { $Dependency.MaximumVersion }
        }
    }
}

$ChildGroups = $ChildModules | Group-Object -Property Name
foreach ($Childgroup in $Childgroups) {
    if (($BicepModules | Select-Object -ExpandProperty ModuleName) -contains $Childgroup.Name) {
        continue
    }
    else {
        try {
            $Mod = Find-Module $ChildGroup.Name -Repository PSGallery
        }
        catch {
            throw "Unable load (dependency) module information from the PowerShell Gallery module: $_"
        }
    
        $Props = @{
            ModuleName     = $Mod.Name
            Version        = $Mod.Version
            Package        = "https://www.powershellgallery.com/api/v2/package/{0}/{1}" -f $Mod.Name, $Mod.Version
            BicepDependsOn = (@(foreach ($Dependency in $Mod.Dependencies) { $Dependency.name.Replace('.', '_') }) + "`tAutomationAccount" | out-string) + "`t"
        }
        $BicepModules += $Props
    }
}

$Bicep_header = "
param location string = resourceGroup().location
param AutomationAccountName string = 'Automation'

resource AutomationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: '`${AutomationAccountName}'
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}
"
$Body_Template = "
resource REPLACEBICEPNAME 'Microsoft.Automation/automationAccounts/modules@2020-01-13-preview' = {
    name: '`${AutomationAccountName}/REPLACEMODULENAME'
    dependsOn: [
        REPLACEDEPENDENCIES]
    properties:{
      contentLink:{
        uri: 'https://www.powershellgallery.com/api/v2/package/REPLACEMODULENAME/REPLACEVERSION'
        version: 'REPLACEVERSION'
      }
    }
  }
"
$Bicep_body = ""
foreach ($Mod in $BicepModules) {
    $BicepRgName = ($Mod.ModuleName).Replace('.', '_')
    $Bicep_bodypart = $Body_Template.Replace('REPLACEBICEPNAME', $BicepRgName).Replace('REPLACEMODULENAME', $Mod.ModuleName).Replace('REPLACEVERSION', $Mod.Version).Replace('REPLACEDEPENDENCIES', $Mod.BicepDependsOn )
    $Bicep_body += $Bicep_bodypart
}
$Bicep_header + $Bicep_body | Out-File $BicepOutputfile -Force