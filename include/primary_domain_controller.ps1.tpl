
function SetStaticIP(){

    $netip = Get-NetIPConfiguration
    $ipconfig = Get-NetIPAddress | ?{$_.IpAddress -eq $netip.IPv4Address.IpAddress}

    Get-NetAdapter | Set-NetIPInterface -DHCP Disabled
    Get-NetAdapter | New-NetIPAddress -AddressFamily IPv4 -IPAddress $netip.IPv4Address.IpAddress -PrefixLength $ipconfig.PrefixLength -DefaultGateway $netip.IPv4DefaultGateway.NextHop
    Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $netip.DNSServer.ServerAddresses
    Write-SSMParameter -type String -Value "static ip set" -Name "domain-controller" -overwrite $true
    Start-Sleep -s 45
}

function RenameComputer() {
    $azs = (Invoke-RestMethod -Method Get -Uri http://169.254.169.254/latest/meta-data/placement/availability-zone).Trim()
    
    # TODO: Split this to add zone dynamically
    $az=$azs.substring($azs.length -1,1)
            
    if ( $az -eq "a") { $newname = "${domain_controller_name}" + "001" }

    if ( $az -eq "b") { $newname = "${domain_controller_name}" + "002" }

    if ( $az -eq "c") { $newname = "${domain_controller_name}" + "003" }

    if ( ([string]::Compare($newName, $env:computerName, $True) -ne 0) ) {
	    $rename = (Get-WmiObject -Class Win32_ComputerSystem).Rename($newName,"${local_password}",'Administrator').ReturnValue
        Write-SSMParameter -type String -Value "rename to $newName" -Name "domain-controller" -overwrite $true
        if ($rename -eq 0) {
            Restart-Computer
            Start-Sleep -s 30
        }
    }
}

function InstallADDS() {
    #set values for domain creation

    $domain_name = "${domain_name}"
    $domain_safe_mode_admin_password = "${domain_safe_mode_admin_password}"
    $domain_mode = "${domain_mode}"
    $domain_netbios_name = "${domain_netbios_name}"
    $forest_mode = "${forest_mode}"

    $Secure_String_Pwd = ConvertTo-SecureString $domain_safe_mode_admin_password -AsPlainText -Force

    # Install AD DS prerequistes
    Write-SSMParameter -type String -Value "configuring DC" -Name "domain-controller" -overwrite $true
    $feature = Install-WindowsFeature AD-Domain-Services, rsat-adds -IncludeAllSubFeature

    if ($feature.ExitCode.value__ -eq 0 -or 1003 ) {
        Write-Host "SUCCESS:  AD DS prerequistes installed"

        # Install AD DS
        Install-ADDSForest -DomainName $domain_name -SafeModeAdministratorPassword $Secure_String_Pwd -DomainMode $domain_mode -DomainNetbiosName $domain_netbios_name -ForestMode $forest_mode -Confirm:$false -Force

        Restart-Service NetLogon -ErrorAction 0

        Write-Host "SUCCESS:  AD DS installed"
        Write-SSMParameter -type String -Value "DC configured" -Name "domain-controller" -overwrite $true

    } else {
        Write-Host "ERROR:  AD DS Failed to install"
    }
}

function CreateADUser() {

    $domain_enterprise_admin_account  = "${domain_enterprise_admin_account}"
    $domain_enterprise_admin_password = "${domain_enterprise_admin_password}"
    
    $Secure_String_Pwd = ConvertTo-SecureString $domain_enterprise_admin_password -AsPlainText -Force
    $Groups = @('domain admins','schema admins','enterprise admins')

    New-ADUser -Name $domain_enterprise_admin_account -AccountPassword $Secure_String_Pwd -Enabled $true -PasswordNeverExpires $true

    $Groups | ForEach-Object{
        Add-ADGroupMember -Identity $_ -Members $domain_enterprise_admin_account
    }
    Write-SSMParameter -type String -Value "domain elevated user created" -Name "domain-controller" -overwrite $true
}

Function WriteCompletionToSSM() {
if ((get-windowsfeature AD-Domain-Services).installed -eq $true){

$netip = Get-NetIPConfiguration
$ipconfig = (Get-NetIPAddress | ?{$_.IpAddress -eq $netip.IPv4Address.IpAddress}).IPAddress


Write-SSMParameter -type String -Value "Complete - $ipconfig" -Name "domain-controller" -overwrite $true
}
else
{
Write-SSMParameter -type String -Value "failed to verify first DC" -Name "domain-controller"}
}

Set-ExecutionPolicy RemoteSigned -Force
#set timezone
$timezone="${timezone}"
tzutil /s "$timezone"
# Disable Firewall
Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled False

net user administrator ${local_password}

SetStaticIP
RenameComputer

if ((get-windowsfeature AD-Domain-Services).installed -eq $false){
InstallADDS
}

CreateADUser
WriteCompletionToSSM