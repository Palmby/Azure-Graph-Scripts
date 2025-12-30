#Assigns MS Graph Permissions to an Identity

$graphid = '00000003-0000-0000-c000-000000000000'
$identity = '' #managed identity name

$graphPermission = @(
    "Directory.Read.All",
    "User.Read.All"
) #You can add additional Permissions in here


Connect-MgGraph


$managedIdentity = get-mgserviceprincipal -filter "displayName eq '$identity'"
$graphprincipal = get-mgserviceprincipal -filter "appid eq '$graphid'"


foreach ($id in $graphPermission)
{
    try{
    $approle = $graphprincipal.AppRoles | where { $_.Value -eq $id -and $_.AllowedMemberTypes -contains "Application"}
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $managedIdentity.id -PrincipalID $managedIdentity.id -ResourceId $graphprincipal.id -approleid $approle.Id -ErrorAction Stop
    write-host "✅ $id added to $identity" -ForegroundColor Green
    }

    catch {
        write-host "🔴 Error Occured with applying $id to identity | Error:  $($_.Exception.Message)" -ForegroundColor Red
    }
}