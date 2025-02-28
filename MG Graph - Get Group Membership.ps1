#Get all Groups and their members

$mgconnection = @{

    ClientID = ''
    TenantID = ''
    CertificateThumbprint = '' 
  }
  
select-mgprofile 'beta'

  Connect-mggraph @mgconnection


  $groups = get-mggroup -all | select "Displayname" , "MailEnabled" , "Mail" , "ID" | sort displayname 


  foreach ($group in $groups)

  {
        $members = Get-MgGroupMember -groupid $group.Id


        
        foreach ($member in $members)

        {
            $m = $member.Id
            $us = get-mguser -userID $m -erroraction silentlycontinue
            
            if ($us -ne $null){
                    $obj = [pscustomobject]@{
                        Name = $us.DisplayName
                        Group = $group.DisplayName
                        }
            
            $obj | export-csv "" -NoTypeInformation -Append

            }

            else {}
        }


       
        
       
  }

  



