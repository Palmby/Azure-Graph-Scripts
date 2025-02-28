##Connect to Key Vault##
$azconnection = @{
    ApplicationID = ''
    CertificateThumbprint = ''
    TenantID = ''
    SubscriptionID = ''
}
##Pull from keyvault##
connect-azaccount @azconnection
#$certthumbprint = get-azkeyvaultsecret "##vaultname##" "##secretname##" -AsPlainText

$mgconnection = @{

    ClientID = ''
    TenantID = ''
    CertificateThumbprint = $certthumbprint

}



connect-mggraph @mgconnection
$AzureJoinedDevices = get-mgbetadevice -all | select displayname, trusttype, operatingsystemversion,Id | where {$_.trusttype -eq "AzureAD"}
$group = get-mgbetagroup -all | where {$_.displayname -eq "sg_windows_10_devices"} | select -ExpandProperty Id


foreach ($azdevice in $AzureJoinedDevices)
{
    $azdevicedisplayname = $azdevice.DisplayName
    $azdeviceid = $azdevice.Id
    if ($azdevice.OperatingSystemVersion -lt "10.0.20*")
    {
        write-output "$azdevicedisplayname is in windows 10 and is being added to the group"
        New-MgGroupMember -groupid "$group" -DirectoryObjectId "$azdeviceid"

    }

    else{}
}