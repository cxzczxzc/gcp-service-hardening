function Wrap {
    Param([scriptblock]$block)
    Write-Host "+ $($block.ToString().Trim())"
    try {
        Invoke-Command -ScriptBlock $block
    } catch {
        Write-Host "ERROR: $_"
    }
}

Start-Transcript -Path "C:\domain-join.log" -Append -Force

Wrap {
    # Check if the computer part of the domain
    if ((gwmi win32_computersystem).partofdomain -eq $false)
    {
        $envs = "prod"

        $value = (Invoke-RestMethod `
              -Headers @{ 'Metadata-Flavor' = 'Google' } `
              -Uri "http://metadata.google.internal/computeMetadata/v1/instance/tags?alt=text")

        $value

        if ($value -Match "dev")
        {
            $envs = "dev"
        }

        $ouPath = "OU=win,OU=gcp,OU=$envs,OU=servers,DC=dnbapp,DC=net"

        $ouPath

        # Download Service Account from CyberArk
        $SAUrl = 'https://pvwaus.dnb.com/AIMWebService/api/Accounts?AppID=z-dreg-gcp&Safe=app-gcp-join&Folder=Root&Object=dnbapp.net_z-dreg-gcp'
        $service_object = Invoke-RestMethod -Uri $SAUrl -Method Get

        $adminUser = ($service_object | Select -ExpandProperty UserName) + '@dnbapp.net'
        $domainmane = ($service_object | Select -ExpandProperty LogonDomain)

        # Create a PSCredential object
        $Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $adminUser, $( ConvertTo-SecureString ($service_object | Select -ExpandProperty Content) -AsPlainText -Force )

        # Join the domain
        Add-Computer -DomainName $domainmane -Credential $Credential -OUPath $ouPath -PassThru -Restart
    } else {
        Write-Host -fore green "I am part of the dnbapp domain!"
    }
}
