function getmggraphtoken {

param(
[parameter(Mandatory=$true)]
[string]$ClientID,
[parameter(Mandatory=$true)]
[string]$TenantID,
[parameter(Mandatory=$true)]
[string]$client_secret

)


$Scope = "https://graph.microsoft.com/.default"

$url = 'https://login.microsoftonline.com/' + $tenantId + '/oauth2/v2.0/token'


$body = @{
    grant_type = "client_credentials"
    client_id = $ClientID
    client_secret = $client_secret
    scope = "https://graph.microsoft.com/.default"
}

$tokenRequest = Invoke-WebRequest -Method Post -Uri $url -ContentType "application/x-www-form-urlencoded" -Body $body

$token = ($tokenRequest.Content | ConvertFrom-Json).access_token

return $token
}


function MGAPICall {
    param (
        [parameter(Mandatory=$true)]
        [string]$uri,
        [parameter(Mandatory=$true)]
        [string]$access_token,
        [parameter(Mandatory=$true)]
        [string]$method
    )


    $headers = @{
    Authorization = "Bearer $access_Token"
    }

    $response = Invoke-RestMethod -Method $method -uri $uri -headers $headers

    return $response.value
}



$token = getmggraphtoken -clientID ''  -TenantID '' -client_secret ''

$info = MGAPICall -access_token $token -method 'get' -uri https://graph.microsoft.com/v1.0/sites?search=*


$info | select weburl, displayname, createdDateTime, lastModifiedDateTime | sort webUrl | export-csv C:\temp\sharepointList.csv -NoTypeInformation

