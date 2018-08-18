<# 
    Mitschrift zum Pluralsight Kurs 
#>

# Simple Report
Write-Host "Simple Report ..."

Get-EventLog -logName "Windows Powershell" |
    ConvertTo-Html -Property MachineName, EventId, TimeGenerated -Title "Windows Powershell Log Information" >FilteredPSLogReport.html

# Multipart Report
Write-Host "Multipart Report..."

$OS = Get-WmiObject -class Win32_OperatingSystem | ConvertTo-HTML -Fragment
$Bios = Get-WmiObject -class Win32_BIOS | ConvertTo-HTML -Fragment
$Services = Get-WmiObject -class Win32_Service | ConvertTo-HTML -Fragment
ConvertTo-HTML -Body "$OS $Bios $Services" -Title "Report" | Out-File MultiStatusReport.html

# Adding CSS
Write-Host "Multipart Report with Css..."

$Css = @"
<style>
table {
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    width: 100%;
}
th {
    padding-top: 12px;
    padding-bottom: 12px;
    text-align: left;
    background-color: #4CAF50;
    color: white;
}
</style>
"@

$OS = Get-WmiObject -class Win32_OperatingSystem | ConvertTo-HTML -Fragment
$Bios = Get-WmiObject -class Win32_BIOS | ConvertTo-HTML -Fragment
$Services = Get-WmiObject -class Win32_Service | ConvertTo-HTML -Fragment
ConvertTo-HTML -Body "$OS $Bios $Services" -Title "Report" -Head $Css | Out-File MultiStatusReportWithCss.html

# Adding external CSS
Write-Host "Multipart Report with external Css..."

$OS = Get-WmiObject -class Win32_OperatingSystem | ConvertTo-HTML -Fragment
$Bios = Get-WmiObject -class Win32_BIOS | ConvertTo-HTML -Fragment
$Services = Get-WmiObject -class Win32_Service | ConvertTo-HTML -Fragment
ConvertTo-HTML -Body "$OS $Bios $Services" -Title "Report" -CssUri "Style.css" | Out-File MultiStatusReportWithExternalCss.html
