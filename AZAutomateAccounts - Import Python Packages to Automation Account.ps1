#import Python Packages into Azure Automation and its dependancies
#NOTICE - this only works for 3.8.. the files will be under C:\python_temp to import for 3.10


Connect-AzAccount

$resourcegroup = Read-Host = "Resource Group: "
$automationname = Read-Host = "Automation Job Name: "


$input = Read-Host = "What Python Package to Insert: "


$packageurl = "https://pypi.org/pypi/$input/json"

$response = Invoke-RestMethod -Uri $packageurl



$wheelUrls = $response.urls | Where-Object { $_.url -like "*.whl" } | Select-Object -ExpandProperty url
$libraries = @()

if($wheelUrls -ne $null){
mkdir C:\python_temp -erroraction silentlycontinue
cd C:\python_temp
pip download $input -d wheel_libraries

$wheelpackages = get-childitem C:\python_temp\wheel_libraries
$wh = $wheelpackages | select name 

foreach ($package in $wh)
{
    $ba = $package -split "-" 
    $basename = ($ba -split "`n")[0] -replace '^@{Name=', ''
    $packageurl = "https://pypi.org/pypi/$basename/json"
    $response = Invoke-RestMethod -Uri $packageurl



    $wheelUrls = $response.urls | Where-Object { $_.url -like "*.whl" } | Select-Object -ExpandProperty url 
    $wheelUrls
    if ($wheelurls.count -gt 1)
    {
        $pac = $wheelUrls | where {$_ -like "*win_amd64*" } | select -first 1
        $libraries += $pac
    }

    else
    {
        $libraries += $wheelUrls
    }
}
}

foreach ($lib in $libraries)
{
    $filename = [System.IO.Path]::getfilenamewithoutextension($lib)
    $package = $filename -split "-" | select -first 1

   New-AzAutomationPython3Package -automationaccountname $automationname -name $package -ResourceGroupName $resourcegroup -ContentLinkUri $lib
}

cd C:\ 
del C:\python_temp -Recurse -Force
