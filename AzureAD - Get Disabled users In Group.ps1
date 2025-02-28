$Azureconnection = @{

            ApplicationID = ''
            TenantID = ''
            CertificateThumbprint = ''
}

Connect-azuread @Azureconnection 


$users = get-azureaduser -all $true | where {$_.accountenabled -eq $false} 

foreach ($user in $users)
{
$objectID = $user.ObjectID
   $license = $user.AssignedLicenses -join ','
   $groups = Get-AzureADUserMembership -ObjectId "$objectID" | select Mail
   $mail = $groups.Mail
   
if ([string]::IsNullOrEmpty($license))
{
    $islicensed = 'n'
}

else
{
    $islicensed = 'y'
}


foreach ($u in $user)
    {
        $prop =  @{

            'User' = $u.DisplayName
            'Groups' = $mail -join ',' 
            'AssignedLicense' = $islicensed

            }


            $obj = new-Object -TypeName PSObject -Property $prop
            $obj | Select-Object User, groups, AssignedLicense |sort-object User | export-csv C:\temp\MCA_disabledusers.csv -NoTypeInformation -Append -Force

    }


}
