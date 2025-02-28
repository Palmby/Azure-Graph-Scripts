#pull all onedrive users and the size of their OneDrives
$adminURL = "" #sharepoint Admin URL Goes here
$tenant = "" #name of your company here


Connect-AzureAD

$users = get-azureaduser -all $true | where-object {$_.accountenabled -eq $true}  #Pulls all active users



connect-sposervice -url $adminURL


foreach ($user in $users)

    {
    

    $Displayname = $user.DisplayName
    $nickname = $user.userprincipalname.replace('@','_').replace('.','_')


    $URL = "https://$($tenant)-my.sharepoint.com/personal/$nickname"
    
    try{
    $OData = get-sposite -identity $URL | select Owner, StorageUsageCurrent, Status
       
   
  
    

   
    
    $object = @{
                    'User' = $DisplayName
                    'CurrentUsage' = ($OData.StorageUsageCurrent /1024) -as [decimal]
                    'SiteURL' = $URL
               }


     $result = New-Object PSObject -property $object
     $result | select User,CurrentUsage, SiteURL | sort User | export-csv C:\temp\TISOneDriveReport.csv -NoTypeInformation -append -force
     


    }

    catch{ write-output "$DisplayName either does not adequate licensing or has not setup OneDrive"}
    }
    

    





