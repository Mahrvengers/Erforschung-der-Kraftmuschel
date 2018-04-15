Get-Service -DisplayName Anmeldedienst | Get-Member
Get-Service -DisplayName Anmeldedienst | ForEach-Object {
    Write-Host $_.StartType
}
Get-Service -DisplayName Anmeldedienst | Format-List -Property *