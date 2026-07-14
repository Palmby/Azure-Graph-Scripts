
function add-automationruntimepackage {

param(
[parameter(Mandatory=$true)]
[string]$subid,

[parameter(Mandatory=$true)]
[string]$rg,

[parameter(Mandatory=$true)]
[string]$accountname,

[parameter(Mandatory=$true)]
[string]$runtimeenv,

[parameter(Mandatory=$true)]
[string]$modulename,

[parameter(Mandatory=$true)]
$moduleversion
)

$contentUri = "https://www.powershellgallery.com/api/v2/package/$ModuleName/$ModuleVersion"

if (-not(get-azcontext)) 
{
    throw "not signed into az accounts. Authenticate using connect-azaccount to continue"
}
$body = @{
    properties = @{
        contentLink = @{
            uri = $contentUri
        }
    }
} | ConvertTo-Json -Depth 5

Invoke-AzRestMethod -Method PUT `
    -Path "/subscriptions/$subid/resourceGroups/$rg/providers/Microsoft.Automation/automationAccounts/$accountName/runtimeEnvironments/$runtimeEnv/packages/$($moduleName)?api-version=2024-10-23" `
    -Payload $body `
    | Out-Null

    write-host "$modulename added to $runtimeenv"
}

function get_package_list {
    param(
    [parameter(Mandatory=$true)]
    [string]$packagename
    )

    $GraphModule = find-module $packagename
    $DependencyList = $GraphModule | select -ExpandProperty Dependencies | ConvertTo-Json | ConvertFrom-Json

    return $DependencyList
}
Connect-AzAccount

$subid = read-host "Subscription ID: "

$rg = read-host "Resource Group: "

$accountname = read-host "Azure Automation Account Name: "

$runtimeenv = read-host "Azure Runtime Enviornment Name: "

$packagename = read-host "package name: "

$list = get_package_list -packagename $packagename

#install packages
foreach ($Dependant in $list)
{
     start-sleep 20
    $ModuleName = $Dependant.Name
    $ModuleVersion = $Dependant.RequiredVersion
    add-automationruntimepackage -subid $subid `
    -rg $rg `
    -accountname $accountname `
    -runtimeenv $runtimeenv `
    -modulename $ModuleName `
    -moduleversion $ModuleVersion `

    
}