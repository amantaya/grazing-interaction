#Requires -version 4.0
Param(
    [parameter(Mandatory=$true,Position=1)]
    [ValidateScript({Test-Path -PathType Container $_ })]
    [alias("Source")]
    [string]$ReferenceFolder,
    [parameter(Mandatory=$true,Position=2)]
    [alias("Destination")]
    [ValidateScript({Test-Path -PathType Container $_ })]
    [string]$DifferenceFolder,
    [parameter(Mandatory=$false)]
    [ValidateSet("SHA1", "SHA256", "SHA384", "SHA512", "MACTripleDES", "MD5", "RIPEMD160")]
	$Algorithm="MD5",
    [parameter(Mandatory=$false)]
    [switch]$ShowMatches
)

$referenceFolderHashes = Get-ChildItem $ReferenceFolder -File -Recurse | Get-FileHash -Algorithm $Algorithm | Select Path,Hash
$differenceFolderHashes = Get-ChildItem $DifferenceFolder -File -Recurse | Get-FileHash -Algorithm $Algorithm | Select Path,Hash

Compare-Object $referenceFolderHashes $differenceFolderHashes -Property Hash -PassThru -IncludeEqual:$ShowMatches.IsPresent | 
    Select-Object Path,@{Name="CopyStatus";Expression={If($_.SideIndicator -eq "=="){"OK"}else{"Check"}}}