#Get all deleted blob within a container
$StorageAccount = Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq "<Your Storage Account Name>" }
$Blobs = Get-AzStorageContainer -Name "<Your Storage Account Container Name>" -Context $StorageAccount.Context | Get-AzStorageBlob -IncludeDeleted

#Get the soft deleted blobs on june 5, 2021
$startDate = Get-Date -Year 2021 -Month 6 -Day 5
$endDate = Get-Date -Year 2021 -Month 6 -Day 6
$DeletedBlobs = $($Blobs | Where-Object { $_.IsDeleted -and $_.ICloudBlob.Properties.DeletedTime -ge $startDate -and $_.ICloudBlob.Properties.DeletedTime -le $endDate })

#Get your Bearer access token, run first Connect-AzAccount to authenticate on Azure
$resource = "https://storage.azure.com"
$context = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile.DefaultContext
$accessToken = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate($context.Account, $context.Environment, $context.Tenant.Id.ToString(), $null, [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, $null, $resource).AccessToken
   
#Restore
foreach ($DeletedBlob in $DeletedBlobs) {
    Write-Host "Restoring : $($DeletedBlob.Name)"
    $uri = "$($DeletedBlob.BlobBaseClient.Uri.AbsoluteUri)?comp=undelete"
    $headers = @{
        'Authorization' = "Bearer $accessToken";
        'x-ms-date'     = $((get-date -format r).ToString());
        'x-ms-version'  = "2017-11-09"; 
    }
    Invoke-RestMethod -Method 'Put' -Uri $uri -Headers $headers
}
