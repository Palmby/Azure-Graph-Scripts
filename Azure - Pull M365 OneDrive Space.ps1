#pull all onedrive users and the size of their OneDrives
$adminURL = #example: "https://palmby-admin.sharepoint.com/"
$tenant = #Example: "Palmby"


Connect-MgGraph

$users = Get-MgUser -all 



connect-sposervice -url $adminURL


foreach ($user in $users)

    {
    $e.clear

    $TISDisplayname = $user.DisplayName
    $TISnickname = $user.userprincipalname.replace('@','_').replace('.','_')


    $URL = "https://$($tenant)-my.sharepoint.com/personal/$TISnickname"
    
    try{
    $OData = get-sposite -identity $URL | select Owner, StorageUsageCurrent, Status
       
   
  
    

   
    
    $object = @{
                    'User' = $TISDisplayName
                    'CurrentUsage' = ($OData.StorageUsageCurrent /1024) -as [decimal]
                    'SiteURL' = $URL
               }


     $result = New-Object PSObject -property $object
     $result | select User,CurrentUsage, SiteURL | sort User | export-csv C:\temp\OneDriveReport.csv -NoTypeInformation -append -force
     


    }

    catch{ write-output "$TISDisplayName error"}
    }
    

    





