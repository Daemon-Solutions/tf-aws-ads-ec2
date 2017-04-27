

Function CheckDomainReadiness{
do{

$param=(Get-SSMParameterValue -Name domain-controller).Parameters.value

sleep -Seconds 1
}
until ($param -like "Complete*")
$results=$param.trim().Split("-")[1]

return $results.trim()
}


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
    $az=$azs.substring($azs.length -1,1)
            
    if ( $az -eq "a") { $newname = "${domain_controller_name}" + "001" }

    if ( $az -eq "b") { $newname = "${domain_controller_name}" + "002" }

    if ( $az -eq "c") { $newname = "${domain_controller_name}" + "003" }

    if ( ([string]::Compare($newName, $env:computerName, $True) -ne 0) ) {
	    $rename = (Get-WmiObject -Class Win32_ComputerSystem).Rename($newName,"${local_password}",'Administrator').ReturnValue
    
        if ($rename -eq 0) {
            Restart-Computer
            Start-Sleep -s 30
        }
    }
}

function ConnectToDomain() {
	$domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain
	$newDomain = "${domain_name}"
	$ad_user = "${domain_enterprise_admin_account}"
	$newDomainPassword ="${domain_enterprise_admin_password}"
	if ( ([string]::Compare($newDomain, $domain, $True) -ne 0) ) {
	  $connect = (Get-WmiObject -Class Win32_ComputerSystem).JoinDomainOrWorkGroup($newDomain,$newDomainPassword,"$ad_user@$newDomain",$null,3).ReturnValue
	  if ($connect -eq 0 ) {
			Restart-Computer
			Start-Sleep -s 30
	  }
	}
}

function InstallADDC() {
    #set values for domain creation
    $domain_enterprise_admin_account  = "${domain_enterprise_admin_account}"
    $domain_enterprise_admin_password = "${domain_enterprise_admin_password}"
    $domain_name = "${domain_name}"
    $domain_safe_mode_admin_password = "${domain_safe_mode_admin_password}"

    $secpasswd = ConvertTo-SecureString $domain_enterprise_admin_password -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential ("$domain_name\$domain_enterprise_admin_account", $secpasswd)
    $Secure_String_Pwd = ConvertTo-SecureString $domain_safe_mode_admin_password -AsPlainText -Force
    Install-ADDSDomainController -DomainName $domain_name -InstallDns -SafeModeAdministratorPassword $Secure_String_Pwd -credential $mycreds -force
}

Set-ExecutionPolicy RemoteSigned -Force

net user administrator ${local_password}

Install-WindowsFeature AD-Domain-Services, rsat-adds -IncludeAllSubFeature
 
SetStaticIP

RenameComputer

$dc_dns=CheckDomainReadiness

Start-Sleep -s 120

Import-Module NetAdapter
$alias = (Get-NetAdapter).Name
Set-DnsClientServerAddress -InterfaceAlias $alias -ServerAddress $dc_dns

start-sleep -s 120

ipconfig /flushdns

ConnectToDomain

InstallADDC
