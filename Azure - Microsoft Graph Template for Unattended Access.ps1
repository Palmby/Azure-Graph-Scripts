#Connect to Microsoft Graphs unattended 


$connection = @{

            ClientID = #'Clients Azure ID'
            TenantID = #'Clients Tenant ID'
            CertificateThumbprint = #'Certificate Thumbprint that was uploaded'

}

Connect-MgGraph @connection