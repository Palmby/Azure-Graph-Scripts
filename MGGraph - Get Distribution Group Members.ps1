
Connect-MgGraph 

$users = Get-MgGroupMember -groupid #"ObjectID of the group"

$u = $users.id 

$userarray = @()

foreach ($user in $u)

{
    $add = get-mguser -userID "$user"

    $userarray += $add
}

$userarray | select Displayname, mail | #export-csv <path to export csv> -NoTypeInformation

