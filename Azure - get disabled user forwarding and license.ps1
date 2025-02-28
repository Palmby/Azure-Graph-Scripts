#MG unattended access
$mgconnection = @{

  ClientID = ''
  TenantID = ''
  CertificateThumbprint = ''
}


#Exchange unattended Access
$Exconnection = @{
AppID = ""
Organization = ""
CertificateThumbprint = ''
}


#Azure Unattended Access
$azconnection = @{
  ApplicationID = ''
  TenantID = ''
  CertificateThumbprint = ''

}

connect-mggraph @mgconnection 
connect-azuread @azconnection 
connect-ExchangeOnline @Exconnection

$users = get-azureaduser -all $true | where {$_.accountenabled -eq $false -and  $_.AssignedLicenses -ne $null}

foreach ($user in $users)
{
  $id = $user.ObjectId
  $licenses = get-mguserlicensedetail -userID "$id"
  $licensetype = @()

foreach ($license in $licenses)
{
  Switch ($license.skuid) #add more licenses in here based on the skuid 
  {
      c5928f49-12ba-48f7-ada3-0d743a3601d5
      {
          $type = 'Microsoft Visio'  
      }

      87bbbc60-4754-4998-8c88-227dca264858
      {
          $type = 'Power Apps and Logic Flows'
      }

      15d3e2bf-8ed6-49f0-ab92-fe89364630ee_f8a1db68-be16-40ed-86d5-cb42ce701560
      {
          $type = 'Power BI Pro'
      }

      6fd2c87f-b296-42f0-b197-1e91e994b900
      {
         $type =  'Office 365 E3'
      }
  
      f30db892-07e9-47e9-837c-80727f46fd3d
      {
          $type = 'Microsoft Power Automate Free'
      }

      dcb1a3ae-b33f-4487-846a-a640262fadf4
      {
          $type = 'Microsoft Power Apps Plan 2 Trial'
      }

      f245ecc8-75af-4f8e-b61f-27d8114de5f3
      {
          $type = 'Microsoft 365 Business Standard'
      }

      a403ebcc-fae0-4ca2-8c8c-7a907fd6c235
      {
          $type = 'Power BI Free'
      }

      0c266dff-15dd-4b49-8397-2bb16070ed52
      {
          $type = 'Microsoft 365 Audio Conferencing '
      }

      84cd610f-a3f8-4beb-84ab-d9d2c902c6c9
      {
          $type = 'Microsoft Project Plan 1'
      }

      3b555118-da6a-4418-894f-7df1e2096870
      {
          $type = 'Microsoft 365 Business Basic'
      }

      53818b1b-4a27-454b-8896-0dba576410e6
      {
          $type = 'Project Plan 3'
      }
  
      cdd28e44-67e3-425e-be4c-737fab2899d3
      {
          $type ='Microsoft 365 Apps for Business'
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





  $permissions = get-mailboxpermission -identity $user.Mail | Where-Object {($_.User -ne "NT AUTHORITY\SELF") -and ($_.IsInherited -ne $true)} | select Identity, User, AccessRights -ErrorAction SilentlyContinue
  $forwarding = Get-Mailbox -identity $i | select identity, Forwardingsmtpaddress, DelivertoMailboxandForward 
  

     

  
  
  


  


if ($licensed = '1'){
  $obj = @{'Name' = $user.displayName; 
           'license' = $licenseuser
           'User With Mailbox Access' = $permissions.user -join ','
           'AccessRights' = $permissions.AccessRights -join ','
           'ForwardingsmtpAddress' = $forwarding.Forwardingsmtpaddress
           'DelivertoMailbox&Forward' = $forwarding.DelivertoMailboxandForward 
          }

  $Result= New-Object PSObject -Property $obj
  $result | export-csv C:\temp\mfastat.csv -NoTypeInformation -append -force

}
}




