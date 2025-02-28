##########Connect to Azure AD Module Template###

#Pre-Req:
## -> Ensure that the Azure AD module is installed on the server 

##Module install Begin###########################################################
# set-executionpolicy unrestricted
# install-module Azure-adpreview
##Module install End#############################################################


## Run the following before first opn the designated Server to input the Cloud Credentials into the Powershell Vault:


#####Begin#################################################################
#[Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
#$vault = New-Object Windows.Security.Credentials.PasswordVault

###**This is where you start adding the creds***
#$cred = New-Object Windows.Security.Credentials.PasswordVault
#$cred.Resource = '*Descriptive name*'
#$cred.Username = '*input the username here*'
#$cred.Password = '*Password for account*'
#$vault.add($cred)
#Remove-Variable cred 

#####End####################################################################




#initialize the Credential manager

[Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
$vault = New-Object Windows.Security.Credentials.PasswordVault


#pull the creds from the Vault
$creds = $vault.RetrieveAll()
$cs = $creds.where({$_.resource -eq "azurepalmby"})
$cs.retrievepassword()

#test the creds
$cs.username
$cs.password 

#convert the password to a secure string 
$securepassword = $cs.password | ConvertTo-SecureString -AsPlainText -Force

#turn creds into an Object
$azurecreds = New-object System.Management.Automation.PSCredential ($cs.username , $securepassword)


$logincreds = Get-Credential -Credential $azurecreds

Connect-AzureAD -Credential $logincreds


##Start Report pull or script here
