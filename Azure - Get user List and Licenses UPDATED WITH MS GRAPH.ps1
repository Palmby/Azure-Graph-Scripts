$mgconnection = @{

  ClientID = ''
  TenantID = ''
  CertificateThumbprint = '' 
}

connect-mggraph @mgconnection
select-mgprofile 'beta'
#connect-azuread @azureconnection
#connect-ExchangeOnline @exchangeconnection


$users = get-mguser -all | where {$_.usertype -eq 'member'} | sort displayname 

foreach ($user in $users)
{
  $id = $user.Id
  $licenses = get-mguserlicensedetail -userID "$id"
  $licensetype = @()
  if ($licenses -ne $null){

  foreach ($license in $licenses)
  {
      switch ($license.skuid){
      
      3b555118-da6a-4418-894f-7df1e2096870
      {
          $type = 'Microsoft 365 Business Basic'
      }

      cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46
      {
        $type = 'Microsoft 365 Business Premium'
      }

      a403ebcc-fae0-4ca2-8c8c-7a907fd6c235
      {
          $type = 'Power BI Free'
      }

      f30db892-07e9-47e9-837c-80727f46fd3d
      {
          $type = 'Microsoft Power Automate Free'
      }

      8c4ce438-32a7-4ac5-91a6-e22ae08d9c8b
      {
          $type = 'Rights Management AdHoc'
      }
  }

  

  if ($type -ne $null)
  {
    $licensetype += "$type" 
    $licenseuser = $licensetype -join ','
  }


  }

  if ($type -eq $null)
  {
    $licensed = '0'
  }

  else 
    {
      $licensed = '1'
    }
  

if ($licensed = '1'){
$obj = @{'Name' = $user.displayName; 
         'license' = $licenseuser
        }
        }

$Result= New-Object PSObject -Property $obj
$result | export-csv "" -NoTypeInformation -append -force
}

else {}
}
