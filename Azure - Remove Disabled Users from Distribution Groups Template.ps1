

#PreReq: Create unattended APP Access in Azure for MG Graph and Exchange Online


#Microsoft Graph Unattended Access
$MGGraphconnection = @{

    ClientID = ''
    TenantID = ''
    CertificateThumbprint = ''
}

#Exchange unattended access 
$ExchangeConnection = @{

    CertificateFilePath = "<cert location>" 
    CertificatePassword = $(ConvertTo-SecureString -String "" -AsPlainText -Force)
    AppID = ""
    Organization = "<organizationname>.onmicrosoft.com"
}

#Connect to Microsoft Graph and Pull list of Disabled users 
Connect-MgGraph @MGGraphconnection

$users = get-mguser -filter 'accountenabled eq false' -All | sort DisplayName
$d_users = $users.DisplayName

Disconnect-MgGraph


#Connect To Exchange Online and Remove Users from any Distribution Groups
Connect-ExchangeOnline @ExchangeConnection

foreach ($d_user in $d_users){

$usermailbox = Get-mailbox -identity $d_user 
$user = Get-mailbox -identity $d_user | select PrimarySmtpAddress
$u = $user.PrimarySmtpAddress

$groups = Get-DistributionGroup | where { (Get-DistributionGroupMember $_.Name | foreach {$_.PrimarySmtpAddress}) -contains "$u"} -ErrorAction SilentlyContinue


#Remove Users From Groups - Uncomment if ready to Remove
foreach ($group in $groups)
{
    Write-output "Removing $u from $group"
    Remove-DistributionGroupMember -Identity "$group" -member "$usermailbox" -Force  #Remove the Force Command if you want to confirm each removal
}
}

Disconnect-ExchangeOnline 