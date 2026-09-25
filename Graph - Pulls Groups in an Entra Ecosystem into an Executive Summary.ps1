
<#
Azure Tenant Group Reporting Script - V1.0.0
Author: Palmby
Purpose: Intended to pull all the Groups in a an Entra Tenant Ecosystem and Publish in an Executive Readable Format Report
FUNDAMENTAL STEPS:
-   Connects to Graph and pulls all the Groups
-   Goes through each Group and calls a Function to Label if the group is a Microsoft365, Distribution, or Security Group
-   Goes through each group and pulls it members, and displays it
#>

#Function to Get the group type
function GetGroupType ($group) {

    switch ($true) {
        ($group.GroupTypes -contains 'unified')
        {
            'Microsoft365Group' ; break
        }

        ($group.mailbox -and $group.SecurityEnabled)
        {
            'MailEnabledSecurityGroup' ; break
        }
        ($group.mailEnabled)
        {
            'DistributionGroup' ; break
        }
        ($group.SecurityEnabled)
        {
            'SecurityGroup' ; break
        }
        Default
        {
            'Unknown' ; break
        }

    }
}

#Does a lookup of the users in the group
function Memberlist ($id) {
    $members = get-mgbetagroupmember -groupid $group.id | select AdditionalProperties

    ($members | foreach {$_.AdditionalProperties['displayName']}) -join ', '
  
    
}

###Actual Code Here###
Connect-MgGraph
$list = @() 
$groups = Get-MgBetaGroup -all | select displayname,GroupTypes,mailEnabled, SecurityEnabled, CreatedDateTime, Id

foreach ($group in $groups)
{
    Write-Host "$($group.displayname) is being queried" -ForegroundColor Magenta -BackgroundColor White
    $records = [PSCustomObject]@{
        GroupName = $group.displayname
        Type = GetGroupType $group
        CreatedTime = $group.CreatedDateTime
        Members = Memberlist $group.Id
    }

    $list += $records 
    

}

#Takes the compiled List and makes it a csv in your C:\<user> location
$list | sort CreatedTime -descending | export-csv "$env:USERPROFILE\TenantGrouplist_$((Get-Date).ToString('MM-dd-yyyy')).csv" -NoTypeInformation
write-host "File save to $env:USERPROFILE" -foregroundcolor green -background White