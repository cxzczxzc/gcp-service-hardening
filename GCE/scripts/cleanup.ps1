<#
.SYNOPSIS
This script demonstrates how to unjoin a computer from a domain using PowerShell.

.DESCRIPTION
This script will unjoin the current computer from a specified domain, using a specified user account.

.PARAMETER Domain
The domain to unjoin.

.PARAMETER User
The user account to use for unjoining the domain.

.PARAMETER Password
The password for the user account.

.PARAMETER Logfile
The logfile to write the output to.

.EXAMPLE
PS C:\> .\Unjoin-Domain.ps1 -Domain "contoso.com" -User "admin" -Password "P@ssw0rd" -Logfile "C:\logs\Unjoin-Domain.log"

This command will unjoin the current computer from the contoso.com domain, using the admin account and the specified password. The output will be written to C:\logs\Unjoin-Domain.log

.NOTES
Author: Your Name
Date: 01/19/2023
#>

# Define the script parameters
    [CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Domain,
    [Parameter(Mandatory=$true)]
    [string]$User,
    [Parameter(Mandatory=$true)]
    [string]$Password,
    [Parameter(Mandatory=$true)]
    [string]$Logfile
)

# Create a PSCredential object
$Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $User, $(ConvertTo-SecureString $Password -AsPlainText -Force)

# Unjoin the domain
Remove-Computer -UnjoinDomaincredential $Credential -PassThru -Reboot | Out-File -FilePath $Logfile -Append

# Display a message to indicate that the computer has been unjoined from the domain
"Successfully unjoined the $Domain domain" | Out-File -FilePath $Logfile -Append

