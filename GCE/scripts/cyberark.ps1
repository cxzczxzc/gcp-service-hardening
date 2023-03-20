# vault-CISAdmin-windows.ps1
# Could possibly move to v10 API, keep that in mind. Would require splitting out group addition to a second call.

<#
.SYNOPSIS
Takes either a hostname or a filename containing a list of hostnames and vaults the CISAdmin account.
By default, vaults the current host.

#>

##############################################################################
# Script Input parameters
##############################################################################

param (
    [Parameter(Mandatory=$false)][string]$hostname,
    [Parameter(Mandatory=$false)][string]$hostfile,
    [Parameter(Mandatory=$false)][string]$adminUser,
    [Parameter(Mandatory=$false)][string]$vaultLogon,
    [Parameter(Mandatory=$false)][string]$hostDomain,
    [Parameter(Mandatory=$false)][switch]$deprovision=$false
)

$VerbosePreference='Continue'
$DebugPreference='Continue'

##############################################################################
# Check Args
##############################################################################

if ($hostDomain -eq '') {
    $hostDomain = (Get-WmiObject win32_computersystem).Domain
    if ($hostDomain -eq 'WORKGROUP') {$hostDomain=$env:userdnsdomain}

}

Write-Debug -Message "Using domain $hostDomain"


# If neither hostname nor hostfile is selected, use the current hostname
if ( ($hostname -and $hostfile) -or ( ! ($hostname -or $hostfile) ) ) {
    $hostnames = @( "$([System.Net.Dns]::GetHostName()).$hostDomain" )
    write-debug -Message "Using hostname `"$hostnames`""

} elseif ($hostname) {
    $hostnames = @($hostname)
} else {
    $hostnames = Get-Content -Path $hostfile | Where-Object { $_ -match '^[^#]' }
}

$hostnames=$hostnames.toLower()

#Write-Error -Message "$hostnames" -ErrorAction Stop


##############################################################################
# Function Defs
##############################################################################


function restBodyAddAcct {
    <#
 .SYNOPSIS
Takes a username, and generates the body section for the REST call that creates the accounts.
Needed to use the 9.x API, since I cannot seem to set PlatformAccountProperties via the 10.5 API
User details for each account are stored in the $acctParams dictionary as a hash-of-hashes.
#>
    param (
        [string]$userName
    )


    $userParams=$acctParams[$userName]
    If ( ! $userParams['Password'] ) { $userParams['Password']='Dumy123!blAh' }

    $bodyString='{{
    "account" : {{
        "safe":"{0}",
        "platformID":"{1}",
        "address":"{2}",
        "accountName":"{2}-{3}",
        "username":"{3}",' -f $UserParams['SafeName'],$userParams['PlatformID'],$hostname,$userName
    if ($userParams['Password']) {
        $bodyString += '
        "password":"' + $userParams['Password'] + '",'
    }
    if ($userParams['groupName']) {
        $bodyString += '
        "groupName":"' + $userParams['groupName'] + '",'
    }
    if ($userParams['groupPlatformID']) {
        $bodyString += '
        "groupPlatformID":"' + $userParams['groupPlatformID'] + '",'
    }



    # Only generate platform properties (ExtraPass1Name, ExtraPass3Safe, etc.) if they are called for by
    # the contents of $userParams. Generate them as a list of multiline strings (won't be more than two,
    # as things are working currently), then join them together. This would be more straightforward in
    # the 10.x API, if it worked.

    # ExtraPass3* is not necessary, since we set it in the platform. Leaving that code in here in case something
    # changes in the future and we end up needing to set it for individual accounts. However, we can't do the same
    # for ExtraPass1*, because although the CPM honors that setting and will use the logon account, PSM
    # and PSMP do not, so we have to set the Logon Account explicitly.

    $platformProps = @()


    <#
    If ($domainRecNames[$hostDomain]) {
        $platformProps += ('        {{"Key":"ExtraPass3Name", "Value":"{2}-{0}"}},
            {{"Key":"ExtraPass3Folder", "Value":"Root"}},
            {{"Key":"ExtraPass3Safe", "Value":"{1}"}}
        ' -f $domainRecNames[$hostDomain]['UserName'],$domainRecNames[$hostDomain]['SafeName'])
    }
#>

    $bodyString += '
        "properties": ['
    $bodyString += ($platformProps -join(",`n"))
    $bodyString += '
        ]
    }
}'

    $bodyString
}

function getAccountID {
    <#
 .SYNOPSIS
Takes a username, and returns the internal account ID (like 23_4567). For now, relies on global $sessionData and $authHeaders.
#>
    param (
        [Parameter(Mandatory=$true)][string]$vaultAccount
    )

    $searchRes=Invoke-RestMethod -method GET -uri "https://$($fqdn)/PasswordVault/API/Accounts?search=$vaultAccount" -Headers $authHeaders -WebSession $sessionData
    Write-Debug -Message "Invoke-RestMethod search returned $($searchres.count) records"
    if ($searchRes.count -eq 0) { Write-Error -Message 'ID search returned no results' -ErrorAction Stop }
    if ($searchRes.count -gt 1) { Write-Error -Message 'ID search returned multiple results' -ErrorAction Stop }

    $foundID=$searchRes.value[0].id
    write-debug -Message "getAccountID found ID $foundID for account $vaultAccount"
    $foundID
}

function getAccountCred {
    <#
.SYNOPSIS
Takes an account ID (like 23_4567) and returns its secret credential.
For now, relies on global sessionData and $authHeaders.
#>
    param (
        [Parameter(Mandatory=$true)][string]$acctID
    )
    Invoke-RestMethod -method POST -uri "https://$($fqdn)/PasswordVault/API/Accounts/$acctID/Password/Retrieve" -Headers $authHeaders -WebSession $sessionData
}

function createAccount {
    <#
.SYNOPSIS
Takes a username name (like 'cyalogon') creates the account per the parameters specified in $acctParams[$username}
#>
    param (
        [Parameter(Mandatory=$true)][string]$username
    )
    write-verbose -Message "create $username"
    $restBody=restBodyAddAcct "$username"
    write-debug -Message $restBody
    $createRes=Invoke-WebRequest -UseBasicParsing -method POST -Uri "https://$fqdn$acctAddPath" -Headers $authHeaders -WebSession $sessionData -body "$restBody"
    write-verbose -Message "$($createRes.StatusCode): $($createRes.StatusDescription)"
}

function triggerAcctAction{
    <#
.SYNOPSIS
Takes an account name (like cyarecon or root), an action (actually the trailing part of the REST URL that comes after the account number, like
"Reconcile", "Change", "Password/Update") and optionally a REST body (defaults to '{}'). It then looks up the account ID based on the current
host, the account name, and the safe for that user (found in AccountParams), and invokes the appropriate call.
#>
    param (
        [Parameter(Mandatory=$true)][string]$acctname,
        [Parameter(Mandatory=$true)][string]$action,
        [Parameter(Mandatory=$false)][string]$body
    )

    if (! $body) { $body='{}' }
    $safename=$acctParams[$acctname]['SafeName']
    Write-Verbose -Message "Attempting action '$action' on account '$acctname' with body '$body'"
    $searchstr="$acctname,$hostname&Filter=safename%20eq%20$safename"
    Write-Debug -Message "Searching for account using search string '$searchstr'"
    $accountID=getAccountID($searchstr)
    Write-Debug -Message "getAccountID returned '$accountID'"
    $restURL="https://$($fqdn)/PasswordVault/API/Accounts/$accountID/$action"
    Write-Debug -Message "Using REST url '$restURL'"
    $webRes=Invoke-RestMethod -UseBasicParsing -method POST -uri $restURL -WebSession $sessionData -body $body
    Write-Debug -Message "$($webRes.StatusCode): $($webRes.StatusDescription)"
}

function deleteAccount {
    <#
.SYNOPSIS
Takes an account ID as returned by getAccountID (like 23_454), and deletes that account from the vault.
#>
    param (
        [Parameter(Mandatory=$true)][string]$accountID
    )

    Write-Verbose "Deleting account $accountID"
    $deleteURL="https://$fqdn/PasswordVault/api/Accounts/$accountID"
    Write-Debug -Message "deleteAccount using $deleteURL"
    $restbody='{}'
    $deleteRes=Invoke-WebRequest -UseBasicParsing -method DELETE -Uri "$deleteURL" -Headers $authHeaders -WebSession $sessionData -body "$restBody"
    Write-Debug -Message "deleteAccount returned `"$deleteRes`""
}

##############################################################################
# Define parameters for each account
##############################################################################

$acctParams=@{}





$domainSpecific=@{};
$domainSpecific['dnbint.net']=@{'Platform'='CISAdmin'; 'SafeName'='CISAdmin'}
$domainspecific['dnbapp.net']=@{'Platform'='CISAdmin-dnbapp'; 'SafeName'='CISAdmin'}
<#
#Add additional domain setups here
$domainSpecific['mdrus.com']=@{'Platform'='CISAdmin-mdrus'; 'SafeName'='CISAdmin-mdrus'}
#>



# Only one account getting defined for each server in this environment
$acctParams=@{}
$acctParams['CISAdmin']=@{
    'PlatformID'=$domainSpecific[$hostDomain]['Platform'];
    'SafeName'=$domainSpecific[$hostDomain]['SafeName']
}


<#
$domainRecNames=@{}

$domainRecNames['dnbapp.net']=@{
  'SafeName'='Reconcile';
  'UserName'='sec-dnbapp-rec'
}

$domainRecNames['dnbint.net']=@{
  'SafeName'='Reconcile';
  'UserName'='sec-dnbint-darec'
}
#>


[Net.ServicePointManager]::SecurityProtocol = 'TLS12'

$fqdn='pvwacnwy.dnb.com'
#$authPathCYA='/PasswordVault/API/auth/CyberArk/Logon'
$authPathCYA='/PasswordVault/WebServices/auth/CyberArk/CyberArkAuthenticationService.svc/Logon'
$authPathRadius='/PasswordVault/API/auth/RADIUS/Logon'
$authPathLDAP='/PasswordVault/API/auth/LDAP/Logon'
$authPathWindows='/PasswordVault/API/auth/Windows/Logon'
$acctAddPath='/PasswordVault/WebServices/PIMServices.svc/Account'


$authHeaders=@{}
$authHeaders['Content-Type']='application/Json'
$authHeaders['Authorization']=''

$adminUser='VaultCISAdmin'
$adminCred='vuatl4Wind0z,plz!'

$authToken=(Invoke-RestMethod -method POST -Uri "https://$fqdn$authPathCYA" -SessionVariable sessionData -Headers $authHeaders -body ('{{
    "username":"{0}",
    "password":"{1}",
    "useRadiusAuthentication":"false",
  }}' -f $adminUser,$adminCred )
).CyberArkLogonResult

$authHeaders['Authorization']=$authToken

write-debug -message "Auth headers = $authHeaders"

if ($deprovision) {
    foreach ($hostname in $hostnames) {
        $safeName=$domainSpecific[$hostDomain]['SafeName']
        $searchstr="CISAdmin,$hostname&Filter=safename%20eq%20$safename"
        Write-Debug -Message "Searching for account using search string '$searchstr'"
        $accountID=getAccountID($searchstr)
        Write-Debug "getAccountID returned $accountID"
        deleteAccount ($accountID)
    }
} else {


    foreach ($hostname in $hostnames) {
        createAccount 'CISAdmin'
    }

    # In order to force immediate reconciliation, we must get the account ID, which will occasionally fail if it is attempted immediately after the account is created, so:

    Write-Debug -message "Sleeping for 10 seconds to allow newly-created account(s) to be searchable in the REST API"
    sleep 10

    foreach ($hostname in $hostnames) {
        triggerAcctAction 'CISAdmin' 'Reconcile'
    }


    # The script can end, but the CYA will still be processing password reconciliation for another few minutes.
    Write-Verbose -Message "All REST operations are complete. Password reconciliation has been scheduled and should finish within a few minutes."
}
