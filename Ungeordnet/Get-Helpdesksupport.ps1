<#
.Synopsis
    Short description

.DESCRIPTION
    Long description
    
.EXAMPLE
    Example how to use this cmdlet
.EXAMPLE
    Another example
#>

<# 
  - Script name
  - Creator
  - Date
  - Updated
  - References, if any
#>

# Parameters
Param (
    [Parameter](Mandatory=$true)[string]$Computername,
    [Parameter](Mandatory=$true)[string]$username
)

# IP Address
$DNSFQDN = Resolve-DnsName -Name $Computername | select Name,IPAddress

# DNS Server
$DNSServer = (Get-DNSClientServerAddress `
    -CimSession (New-CimSession -Computername $Computername) `
    -InterfaceAlias "ethernet0" -AddressFamily IPv4).ServerAddress

# OS Description
$OS = (Get-CimInstane Win32_OperatingSystem -Computername $Computername).Caption

# System Memory
$memory = ((((Get-CimInstance Win32_PhyicalMemory -Computername $Computername).Capacity|Measure -sum).sum)/1gb)

# Last Reboot
$reboot = (Get-CIMInstance -Class Win32_OperatingSystem -Computername $Computername).LastBootUpTime

# Diskspace/Free space
$drive -Invoke-Command -Computername $Computername {Get-PSDrive | Where Name -EQ "C"}
$Freespace = [Math]::Round($drive.free/1gb,2)

# UserInfo
$LastLogonUser = (Get-ADUser -Identity $username -Property *).LastLogonDate
if ($LastLogonUser -eq $null) {
    $LastLogonUser = "User has not logged onto network since account creation"
}

# Retrieve Group Membership
$ADGroupMembership = (Get-ADUser -Identity $username -Property *).memberof

# Printer
$printers = Get-Printer -Computername | Select -Property Name,DriveName,Type | ft -AutoSize

# // Write-Host ...