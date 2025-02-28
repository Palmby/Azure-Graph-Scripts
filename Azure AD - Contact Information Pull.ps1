Connect-AzureAD
$users = get-azureaduser -all $true 

foreach ($user in $users){

$prop = @{

"Name" = $user.DisplayName
"Mail" = $user.mail
"Title" = $user.jobtitle 
"Department" = $user.department
"Office Number" = $user.telephoneNumber
"Mobile" = $user.mobile
"Office" = $user.PhysicalDeliveryOfficeName
}

$object = New-Object -TypeName PSObject -propert $prop

foreach ($o in $object)
{
    $user = $o.name
    write-output $o | ConvertTo-Json | out-file C:\temp\$o.DisplayName.json 
}    

}

