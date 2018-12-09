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
function Get-DiensteMitProblemen {
    <#
        .SYNOPSIS
        Ruft eine Liste mit Diensten ab, die automatisch gestartet werden sollten, aber aktuell nicht laufen.
        .EXAMPLE
        Get-DiensteMitProblemen 

        Ruft die Liste der Dienste mit Problemen ab. Die Ausgabe kann in weitere Cmdlets
        gepiped werden (z.B. Start-Service).
        
        .EXAMPLE
        Get-DiensteMitProblemen -InDialogAnzeigen

        Zeigt die Dienste mit Problemen in einem Dialog an.
    #>
    [CmdletBinding()]
    Param(
        [Switch]$InDialogAnzeigen
    )

    Process {
        $dienste = Get-Service | Where-Object {
            $_.StartType -EQ "Automatic" -and $_.Status -NE "Running"
        }

        if ( $InDialogAnzeigen ) {
            $dienste | Select-Object Name, Status, DisplayName | Out-GridView -Title "Dienste, die automatisch starten sollten, aber nicht laufen"
        }
        else 
        {
            $dienste
        }
    }
}



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


<#
# Übersicht Logs (Was sind die markanten Fehler?)
$heute = Get-Date 
$vor30Tagen = $heute.AddDays(-30).Date 
$Event = Get-EventLog -log System -EntryType Error,Warning -after $vor30Tagen |select eventid,TimeGenerated,source,message  
$Event | Group-Object -Property eventID,message | 
    Sort-Object -Descending count |
    Where-Object count -GT 1 | 
    Select-Object count, name 
    
# 2. Wir brauchen den vollen Fehlertext für die wichtigsten Fehler

$Event | 
    Group-Object -Property eventID,message | 
    Sort-Object -Descending count |
    Where-Object count -GT 1 | 
    Select-Object count, name | 
    Format-List -Property * 
    
    #>