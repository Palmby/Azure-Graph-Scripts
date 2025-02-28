#Get Disabled Users and Hide from GAL

#$AzureAD unattended Access
$connection = @{

    ApplicationID = ''
    TenantID = ''
    CertificateThumbprint = ''
}


$ExchangeConnection = @{

    CertificateFilePath = "C:\temp\exocert.pfx" 
    CertificatePassword = $(ConvertTo-SecureString -String "" -AsPlainText -Force)
    AppID = ""
    Organization = ""
}


connect-azuread @connection

$DU = get-azureaduser -all $true | where {$_.accountenabled -eq $false} | select userprincipalname
$users = $DU.userprincipalname
$users

connect-ExchangeOnline @ExchangeConnection

foreach ($user in $users)
{
    set-mailbox -identity $user -HiddenFromAddressListsEnabled $true
    write-output "Hiding $user From GAL" 
}

