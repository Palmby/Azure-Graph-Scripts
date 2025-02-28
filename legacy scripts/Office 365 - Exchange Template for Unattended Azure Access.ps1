$connection = @{

    CertificateFilePath = #"pfx file (if not installed in Cert store)" 
    CertificatePassword = $(ConvertTo-SecureString -String #'Certificatepasswordhere' -AsPlainText -Force)
    AppID = #'appID'
    Organization = #"domainhere.onmicrosoft.com"
}

Connect-exchangeonline @connection