Connect-AzAccount

#Variables
$resourceGroup = Read-Host "Resource Group?: "
$AutomationAccount = Read-Host "Automation Account?: "

##Install Runtime 5.1##

#Install Microsoft.Graph
$GraphModule = find-module Microsoft.Graph
$DependencyList = $GraphModule | select -ExpandProperty Dependencies | ConvertTo-Json | ConvertFrom-Json
$ModuleVersion = $GraphModule.Version

foreach ($Dependant in $DependencyList)
{
    start-sleep 20
    $ModuleName = $Dependant.Name
    $ModuleVersion = $Dependant.Version
    $ContentLink = "https://www.powershellgallery.com/api/v2/package/$ModuleName/$ModuleVersion"
    New-AzAutomationModule -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -Name $ModuleName -ContentLinkUri $ContentLink -runtimeversion 5.1 -ErrorAction Stop | Out-Null
    write-output "$ModuleName being installed to $AutomationAccount"
}

#Install Microsoft.Graph.Beta
$GraphModule = find-module Microsoft.Graph.Beta
$DependencyList = $GraphModule | select -ExpandProperty Dependencies | ConvertTo-Json | ConvertFrom-Json
$ModuleVersion = $GraphModule.Version

foreach ($Dependant in $DependencyList)
{
    start-sleep 20
    $ModuleName = $Dependant.Name
    $ModuleVersion = $Dependant.Version
    $ContentLink = "https://www.powershellgallery.com/api/v2/package/$ModuleName/$ModuleVersion"
    New-AzAutomationModule -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -Name $ModuleName -ContentLinkUri $ContentLink -runtimeversion 5.1 -ErrorAction Stop | Out-Null
    write-output "$ModuleName being installed to $AutomationAccount"
}

#install Exchange Online Management 
$GraphModule = find-module ExchangeOnlineManagement
$DependencyList = $GraphModule | select -ExpandProperty Dependencies | ConvertTo-Json | ConvertFrom-Json
$ModuleVersion = $GraphModule.Version

foreach ($Dependant in $DependencyList)
{
    start-sleep 20
    $ModuleName = $Dependant.Name
    $ModuleVersion = $Dependant.Version
    $ContentLink = "https://www.powershellgallery.com/api/v2/package/$ModuleName/$ModuleVersion"
    New-AzAutomationModule -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -Name $ModuleName -ContentLinkUri $ContentLink -runtimeversion 5.1 -ErrorAction Stop | Out-Null
    write-output "$ModuleName being installed to $AutomationAccount"
}

##install runtime version 7.2##

#Install Microsoft.Graph
$GraphModule = find-module Microsoft.Graph
$DependencyList = $GraphModule | select -ExpandProperty Dependencies | ConvertTo-Json | ConvertFrom-Json
$ModuleVersion = $GraphModule.Version

foreach ($Dependant in $DependencyList)
{
    start-sleep 20
    $ModuleName = $Dependant.Name
    $ModuleVersion = $Dependant.Version
    $ContentLink = "https://www.powershellgallery.com/api/v2/package/$ModuleName/$ModuleVersion"
    New-AzAutomationModule -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -Name $ModuleName -ContentLinkUri $ContentLink -runtimeversion 7.2 -ErrorAction Stop | Out-Null
    write-output "$ModuleName being installed to $AutomationAccount"
}

#Install Microsoft.Graph.Beta
$GraphModule = find-module Microsoft.Graph.Beta
$DependencyList = $GraphModule | select -ExpandProperty Dependencies | ConvertTo-Json | ConvertFrom-Json
$ModuleVersion = $GraphModule.Version

foreach ($Dependant in $DependencyList)
{
    start-sleep 20
    $ModuleName = $Dependant.Name
    $ModuleVersion = $Dependant.Version
    $ContentLink = "https://www.powershellgallery.com/api/v2/package/$ModuleName/$ModuleVersion"
    New-AzAutomationModule -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -Name $ModuleName -ContentLinkUri $ContentLink -runtimeversion 7.2 -ErrorAction Stop | Out-Null
    write-output "$ModuleName being installed to $AutomationAccount"
}

#install Exchange Online Management 
$GraphModule = find-module ExchangeOnlineManagement
$DependencyList = $GraphModule | select -ExpandProperty Dependencies | ConvertTo-Json | ConvertFrom-Json
$ModuleVersion = $GraphModule.Version

foreach ($Dependant in $DependencyList)
{
    start-sleep 20
    $ModuleName = $Dependant.Name
    $ModuleVersion = $Dependant.Version
    $ContentLink = "https://www.powershellgallery.com/api/v2/package/$ModuleName/$ModuleVersion"
    New-AzAutomationModule -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -Name $ModuleName -ContentLinkUri $ContentLink -runtimeversion 7.2 -ErrorAction Stop | Out-Null
    write-output "$ModuleName being installed to $AutomationAccount"
}
