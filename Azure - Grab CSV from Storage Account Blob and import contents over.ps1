Connect-AzAccount


$rg = ""#Resource Group
$sa = ""#Storage Account
$filename = ""#Blob File
$context = new-azstoragecontext -StorageAccountName $sa -UseConnectedAccount
 
$blob = Get-AzStorageBlob -Container $container -Blob $filename -Context $context



$tempPath = [System.IO.Path]::GetTempFileName()

$blobfileparam = @{
    Container = $container 
    Blob = $filename 
    Destination = $tempPath
    Context = $context
    Force = $true
}

Get-AzStorageBlobContent @blobfileparam

$csvData = Import-Csv -Path $tempPath