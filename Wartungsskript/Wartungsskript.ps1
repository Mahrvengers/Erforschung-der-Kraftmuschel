<#
.SYNOPSIS
    Unser Wartungsskript
#>


<# 
    Ziele:
    1. Dienste abrufen 
    2. Ereignisse prüfen
    3. Ereignislogs rotieren
    --> wevtutil -help  (Archivieren, prüfen, Limitieren)
    4. Backups checken
    5. Netzwerkinformationen sammeln (WLAN usw.)
    6. Status Updates + Ausführung Updates
    7. Remote Prüfung aller vorgegangenen Ziele 
    8. einfache visuelle Oberfläche für alles
    9. Dienste White/Blacklisten für Prüfungen
    10. Logs prüfen: bessere Übersicht über GUI
#>

# Dienste abrufen
<#
Get-Service | Where-Object {
    $_.StartType -EQ "Automatic" -and $_.Status -NE "Running"
}  | Out-GridView -Title "Dienste, die automatisch gestartet werden sollten, aber nicht laufen?" -Wait
#>

# Ereignisse prüfen
<#
$heute = Get-Date
$vor30Tagen = $heute.AddDays(-30).Date
$Event = Get-EventLog -log System -EntryType Error,Warning -after $vor30Tagen |select eventid,TimeGenerated,source,message 
$Event | Group-Object -Property eventID,message | ForEach-Object {
    $_.Group | Out-GridView -Title $_.Name -Wait
    }
#>

