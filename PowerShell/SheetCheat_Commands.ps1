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

#Get list of verbs
Get-Verb

#Get the list of commands
Get-Commmand

#Get all commands with file in its name
Get-Command *file*

#Calling also with the 2 parameters below
Get-Command -commandType function, cmdlet

#Get the commands with the ACL in the name as a noun
Get-Command -Noun ACL

#Get the commands with the Get in the name as a Verb
Get-Command -Verb Get

#Get the commands with the service in the name as a noun
Get-Command *service*

<#We can combine even#>
#Get the commands that has in a name 'share'(as noun) and 'Re<something>'(as verb)
Get-Command -noun *share* -verb Re*

Get-Command -commandType cmdlet

Get-Command -commandType function

Get-Command -commandType alias


#------
gcm -noun computer

#Show all services (running - stopped) on the pc
Get-Service

#To see help 
help Get-Service

## ---- Fin Commands previously used
Ctr + R 

