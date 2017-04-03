# TODO
# - Create log function
# - Split this to add zone dynamically
# - Locale?

Set-ExecutionPolicy RemoteSigned -Force

# Disable Firewall
Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled False

net user administrator ${local_password}

function SetStaticIP(){

    $netip = Get-NetIPConfiguration
    $ipconfig = Get-NetIPAddress | ?{$_.IpAddress -eq $netip.IPv4Address.IpAddress}

    Get-NetAdapter | Set-NetIPInterface -DHCP Disabled
    Get-NetAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $netip.IPv4Address.IpAddress -PrefixLength $ipconfig.PrefixLength -DefaultGateway $netip.IPv4DefaultGateway.NextHop
    Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $netip.DNSServer.ServerAddresses

    Start-Sleep -s 45
}

function RenameComputer() {
    $azs = (Invoke-RestMethod -Method Get -Uri http://169.254.169.254/latest/meta-data/placement/availability-zone).Trim()
    
    # TODO: Split this to add zone dynamically
    $azs.substring($azs.length -1,1)
            
    if ( $az -eq "a") { $newname = "addc-eu-west-1" }

    if ( $az -eq "b") { $newname = "addc-eu-west-2" }

    if ( $az -eq "c") { $newname = "addc-eu-west-3" }

    if ( ([string]::Compare($newName, $env:computerName, $True) -ne 0) ) {
	    $rename = (Get-WmiObject -Class Win32_ComputerSystem).Rename($newName,"${local_password}",'Administrator').ReturnValue
        if ($rename -eq 0) {
            Restart-Computer
            Start-Sleep -s 30
        }
    }
}

function InstallADDS() {

    # Install AD DS prerequistes
    $feature = Install-WindowsFeature AD-Domain-Services, rsat-adds -IncludeAllSubFeature

    if ($feature.ExitCode.value__ -eq 0 -or 1003 ) {
        Write-Host "SUCCESS:  AD DS prerequistes installed"

        # Install AD DS
        Install-ADDSForest -DomainName $domain_name -SafeModeAdministratorPassword $domain_safe_mode_admin_password -DomainMode $domain_mode -DomainNetbiosName $domain_netbios_name -ForestMode $forest_mode -Confirm:$false -Force

        Restart-Service NetLogon -ErrorAction 0

        Write-Host "SUCCESS:  AD DS installed"

    } else {
        Write-Host "ERROR:  AD DS Failed to install"
    }
}

function CreateADUser() {

    $Groups = @('domain admins','schema admins','enterprise admins')

    New-ADUser -Name $domain_enterprise_admin_account -AccountPassword $domain_enterprise_admin_password -Enabled $true -PasswordNeverExpires $true

    $Groups | ForEach-Object{
        Add-ADGroupMember -Identity $_ -Members $domain_enterprise_admin_account
    }
}

SetStaticIP
RenameComputer
Install-ADDS
CreateADUser