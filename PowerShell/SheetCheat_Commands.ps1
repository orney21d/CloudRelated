https://aka.ms/powershell


#Version Info
$PSVersionTable

#Path of PS app
get-command pwsh


<#INI To Install Powershell#>
#Release Tool-To install Powershell
1 - Find-Module PSReleaseTools

#Install module
2 - Install-Module PSReleaseTools

#Tell current last stable version from GitHub 
3 - Get-PSReleaseCurrent

#Get assets
4-Get-PSReleaseasset -Family Windows -Only64Bit


#Save Prerelease file
Get-PSReleaseasset -Family Windows -Only64Bit -Format msi | Save-PSReleaseAsset -Path 'C:\GitRepo\AzureDevops\OEMS\PowerShell\Pluralsight\Installing and Running PowerShell' -WhatIf

#Install PS 
Install-Powershell -EnableRemoting -EnableContextMenu

<#END To Install Powershell#>


#clear screen
Clear-Host

#Info about PS
pwsh

#Navigate to appdata from env variable
cd $env:appdata

#Find recursive inside Microsoft folder.
dir .\Microsoft -Recurse

#Find all file extensions .lnk inside the directory "Microsoft"
dir .\Microsoft\*.lnk -Recurse
