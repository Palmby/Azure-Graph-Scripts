#Create Self Signed Cert
$newcert = @{
    DnsName = 'none.local' #this can be anything, but DO NOT SPECIFY THE TENANT DOMAIN!!!
    certstorelocation = "cert:\currentuser\my"
    NotAfter = (get-date).addyears(30) #edit this if you want to add more TTL
    keyspec = 'KeyExchange'

}

#Export cert as .pfx
$mycert = New-SelfSignedCertificate @newcert

$exportcert = @{

            filepath = 'C:\temp\exocert.pfx'
            password = $(ConvertTo-SecureString -String "<insert Password>" -AsPlainText -Force)
}

$mycert | Export-PfxCertificate @exportcert 


#Export cert as .cer file
$mycert | Export-Certificate -filepath C:\temp\Exocert.cer 
