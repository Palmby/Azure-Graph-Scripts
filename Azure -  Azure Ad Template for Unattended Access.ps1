#Template to connect to Azure AD unatended 

$connection = @{

    TenantID = #'Azure TenantID'
    ApplicationID = #'Azure Application ID'
    CertificateThumbprint = #'Certificate Thumbprint of cert uploaded to Azure'
}


Connect-AzureAD @connection 