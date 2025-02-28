

Connect-MgGraph -scopes "User.Read.All","Userauthenticationmethod.Read.All"
select-mgprofile 'beta'
#Get all users
$users = Get-MgUser -All -Filter "UserType eq 'Member'"


foreach ($user in $users)
{
    $Name = $user.Displayname
    $UPN = $user.UserPrincipalName 
    
    #Get Account Status
    if($user.accountenabled -eq $true)
    {
        $signinstatus = "Allowed"
    }

    else
    {
        $signinstatus = 'Blocked'
    }

    #Get License Status 
    if (($user.AssignedLicenses).count -ne 0)
    {
        $licensestatus = "Licensed"
    }

    else
     {
        $licensestatus = "Unlicensed"   
     }
    $Is3rdPartyAuthenticatorUsed="False"
    $MFAPhone="-"
    $MicrosoftAuthenticatorDevice="-"
    [array]$MFAData = get-mguserauthenticationmethod -userID $user.ID
     $AuthenticationMethod=@()
     $AdditionalDetails=@()

     foreach ($MFA in $MFAData)
     {
        Switch ($MFA.AdditionalProperties["@odata.type"]) 
   { 
    "#microsoft.graph.passwordAuthenticationMethod"
    {
     $AuthMethod     = 'PasswordAuthentication'
     $AuthMethodDetails = $MFA.AdditionalProperties["displayName"] 
    } 
    "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod"  
    { # Microsoft Authenticator App
     $AuthMethod     = 'AuthenticatorApp'
     $AuthMethodDetails = $MFA.AdditionalProperties["displayName"] 
     $MicrosoftAuthenticatorDevice=$MFA.AdditionalProperties["displayName"]
    }
    "#microsoft.graph.phoneAuthenticationMethod"                  
    { # Phone authentication
     $AuthMethod     = 'PhoneAuthentication'
     $AuthMethodDetails = $MFA.AdditionalProperties["phoneType", "phoneNumber"] -join ' ' 
     $MFAPhone=$MFA.AdditionalProperties["phoneNumber"]
    } 
    "#microsoft.graph.fido2AuthenticationMethod"                   
    { # FIDO2 key
     $AuthMethod     = 'Fido2'
     $AuthMethodDetails = $MFA.AdditionalProperties["model"] 
    }  
    "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod" 
    { # Windows Hello
     $AuthMethod     = 'WindowsHelloForBusiness'
     $AuthMethodDetails = $MFA.AdditionalProperties["displayName"] 
    }                        
    "#microsoft.graph.emailAuthenticationMethod"        
    { # Email Authentication
     $AuthMethod     = 'EmailAuthentication'
     $AuthMethodDetails = $MFA.AdditionalProperties["emailAddress"] 
    }               
    "microsoft.graph.temporaryAccessPassAuthenticationMethod"   
    { # Temporary Access pass
     $AuthMethod     = 'TemporaryAccessPass'
     $AuthMethodDetails = 'Access pass lifetime (minutes): ' + $MFA.AdditionalProperties["lifetimeInMinutes"] 
    }
    "#microsoft.graph.passwordlessMicrosoftAuthenticatorAuthenticationMethod" 
    { # Passwordless
     $AuthMethod     = 'PasswordlessMSAuthenticator'
     $AuthMethodDetails = $MFA.AdditionalProperties["displayName"] 
    }      
    "#microsoft.graph.softwareOathAuthenticationMethod"
    { 
      $AuthMethod     = 'SoftwareOath'
      $Is3rdPartyAuthenticatorUsed="True"            
    }
    
   }
   $AuthenticationMethod +=$AuthMethod
   if($AuthMethodDetails -ne $null)
   {
    $AdditionalDetails +="$AuthMethod : $AuthMethodDetails"
   }
 


}


 #To remove duplicate authentication methods
 $AuthenticationMethod =$AuthenticationMethod | Sort-Object | Get-Unique
 $AuthenticationMethods= $AuthenticationMethod  -join ","
 $AdditionalDetail=$AdditionalDetails -join ", "
 $Print=1
 #Determine MFA status
 [array]$StrongMFAMethods=("Fido2","PhoneAuthentication","PasswordlessMSAuthenticator","AuthenticatorApp","WindowsHelloForBusiness")

 if([string]::IsNullOrEmpty($AdditionalDetails)){
    $MFAStatus ="Disabled"
 }
 
 else{
 $MFAStatus="Enabled"
 }

 if($LicensedUsersOnly.IsPresent -and ($LicenseStatus -eq "Unlicensed"))
  {
   $Print=0
  }

  if($Print -eq 1)
  {
   $Result=@{'Name'=$Name;'UPN'=$UPN;'License Status'=$LicenseStatus;'SignIn Status'=$SigninStatus;'Authentication Methods'=$AuthenticationMethods;'MFA Status'=$MFAStatus;'MFA Phone'=$MFAPhone;'Microsoft Authenticator Configured Device'=$MicrosoftAuthenticatorDevice;'Is 3rd-Party Authenticator Used'=$Is3rdPartyAuthenticatorUsed;'Additional Details'=$AdditionalDetail} 
   $Results= New-Object PSObject -Property $Result 
   $Results | Select-Object Name,UPN,Department,'License Status','SignIn Status','Authentication Methods','MFA Status','MFA Phone','Microsoft Authenticator Configured Device','Is 3rd-Party Authenticator Used','Additional Details' | Export-Csv C:\temp\MFAstatus.csv -NoTypeInformation -Append
  }  

     }

