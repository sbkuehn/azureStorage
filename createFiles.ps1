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
  Generates files based upon file size and number of files for a local or remote file share.

.DESCRIPTION
  Particularly helpful in testing scenarios, this script will build out a number of files for interacting with Azure Storage. 

.PARAMETER 
  Required: file number, file size, and file path.

.INPUTS
  File size should be in bytes. As a frame of reference, here are a few different sizes to possibly use in the script:
  1 kilobyte = 1,024 bytes
  1 megabyte = 1,048,576 bytes
  1 gigabyte = 1,073,741,824 bytes

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Shannon Kuehn
  Creation Date:  2019.09.08
  Purpose/Change: Initial script development
  
.EXAMPLE
  CreateFiles -fileNumber 3 -fileSize 1024 -filePath "\\server\share\folder\"
#>

Function CreateFiles {

    param(
        [Parameter(Mandatory=$true)]
        [string]$fileNumber,
        [Parameter(Mandatory=$true)]
        [array]$fileSize,
        [Parameter(Mandatory=$true)]
        [string]$filePath
    )

New-Item -ItemType Directory $filePath
Set-Location -Path $filePath -PassThru
Write-host "Creating files"
for($i=0; $i -lt $fileNumber; $i++)
    {
        $out = New-Object byte[] $fileSize; 
        (New-Object Random).NextBytes($out); 
        [IO.File]::WriteAllBytes($directory+"$([guid]::NewGuid().ToString()).txt", $out)
    }
}
