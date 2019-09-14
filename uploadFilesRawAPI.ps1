<#
© 2019 Microsoft Corporation. 
All rights reserved. Sample scripts/code provided herein are not supported under any Microsoft standard support program 
or service. The sample scripts/code are provided AS IS without warranty of any kind. Microsoft disclaims all implied 
warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event 
shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for 
any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of 
business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or 
documentation, even if Microsoft has been advised of the possibility of such damages.

.SYNOPSIS
  Stores a number of variables, grabs all files sitting in a local or remote file share, and uploads the files to an Azure Storage 
  Account.

.DESCRIPTION
  This script will upload files to Azure Storage with a PutBlob call, using a shared access signature (SAS) key. Generating the header
  is difficult, so using a SAS key will be easier.

.PARAMETER 
  Required: storage account name, storage account container, shared access signature key, file path, and files

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Shannon Kuehn
  Creation Date:  2019.09.09
  Purpose/Change: Initial script development
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$storageAccountName,
    [Parameter(Mandatory=$true)]
    [string]$storageContainer,
    [Parameter(Mandatory=$true)]
    [string]$sasKey,
    [Parameter(Mandatory=$true)]
    [string]$filePath
)

$files = Get-ChildItem -Path $filePath -Recurse -Force
$headers = @{}
$headers.Add("x-ms-blob-type","BlockBlob")

ForEach ($file in $files){
    $uri = "https://"+$storageAccountName+".blob.core.windows.net/"+$storageContainer+"/"+$file+$sasKey
    Invoke-RestMethod -uri $uri -Method Put -InFile $file -ContentType "plain/text" -Headers $headers -Verbose
}
