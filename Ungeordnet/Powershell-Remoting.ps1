<#
    Powershell Remoting
    https://app.pluralsight.com/player?course=powershell-getting-started&author=michael-bender&name=powershell-getting-started-m4&clip=0
#>

<#
    Hinweise: 
      - Clients mit Windows 8, 8.1 und 10 haben per Default kein aktiviertes 
        Powershell Remoting. Aus Sicherheitsgründen.
        Zum Testen müssen wir das aber ggf. einschalten :).

      - Powershell Remoting basiert auf dem Windows Service WinRm. WinRm kommuniziert
        über ein Protokoll namens WS-Man. Dieses Protokoll basiert auf HTTP.
        Daher kann man HTTP oder HTTPS für die Remote Connections verwenden.
#>


## IN EINEM DOMÄNENNETZWERK:

# Aktivieren von Powershell Remoting auf dem ZIELCOMPUTER

# in einer administrativen Powershell:

Enable-PSRemoting # PS-Remoting aktivieren

# * Dem Benutzer (AD oder lokaler Benutzer des anderen Rechners) Zugriff auf PS-Remoting geben
#  - in das Snap in für lokale Benutzer und Gruppen gehen
#  - Administratoren-Gruppe öffnen
#  - "Hinzufügen" klicken
#  - "Advanced" klicken
#  - "Find Now" klicken
#  - "HelpDeskRemoteSupport" aus der Domäne hinzufügen.

Set-PSSessionConfiguration -Name Microsoft.Powershell -ShowSecurityDescriptorUI 
#   - öffnet ein UI-Fenster
#   - da "Add" drücken
#   - "HelpDeskRemoteSupport" hier ebenfalls hinzufügen
#   - Dann die Gruppe in der Listenansicht auswählen und Read, Write und Execute-Recht anhaken

# ....
# Wechsel zum Quell-Computer, von dem aus du die Powershell Remoting Session auf machen
# möchtest
Enter-PSSession -ComputerName Client02
# ... und willkommen auf dem Remote System...


## AUßERHALB VON EINEM DOMÄNENNETZWERK zusätzlich:
# Müssen wir "trusted hosts" benutzen.

# Auf dem QUELLCOMPUTER:
# Hier ist die Liste, normalerweise ist sie leer:
Get-Item WSMan:\localhost\Client\TrustedHosts
# Allen Hosts vertrauen (ein bisschen Wagemutig):
Set-Item WSMan:\localhost\Client\TrustedHosts -Value *
# Nur einem bestimmten Host vertrauen:
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "Webserver01"

# -------------------------------------------------------------------------------------

# Modifizierung der Firewall am Zielsystem, so dass Legacy-Commands funktionieren
Get-NetFirewallRule | Where DisplayName -Like "*Windows Management Instrumentation*" | Select DisplayName,Name,Enabled
# Die sind vermutlich alle "Enabled = False"
# Aktivieren wir diese also : 
Get-NetFirewallRule | Where DisplayName -Like "*Windows Management Instrumentation*" | Set-NetFirewallRule -Enabled True -Verbose

# JETZT IST POWERSHELL REMOTING KORREKT KONFIGURIERT
# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------

# Nächster Abschnitt : Working with variables (für Powershell Remoting)
#

# Es gibt in der Powershell eine ganze Reihe von eingebauten Variablen.
Get-Variable

# Wir wollen eine Variable verwenden, damit wir bei unserem Remoting nicht ständig
# den Namen des Zielcomputers angeben müssen.
$Computername = "Client02"

# Den Inhalt können wir so abrufen:
$Computername

# Das können wir auch in Ausgaben verwenden:
Write-Output "The name of the remote computer is $Computername"

# Wenn wir ' statt " verwenden, dann wird $Computername nicht ersetzt
Write-Output 'The name of the remote computer is $Computername'

# ----------
#
# Nächster Abschnitt : Powershell Remoting Optionen
#

# Es gibt folgende Optionen:
#   - -Computername Parameter (Einige CmdLets sind von vornherein so ausgestattet)
#   - *-PSSession cmdlets (Damit man auf den anderen Rechner wechseln kann)
#   - Invoke-Command (Damit man beliebige Befehle auf dem anderen Rechner ausführen kann)
#   - New-CimSession (älter, funktioniert mit einigen Legacy-Befehlen auch wenn diese PSRemoting-inkompatibel sind)

# Im folgenden probieren wir all diese unterschiedlichen Powershell-Remoting
# Möglichkeiten durch.

help Get-Service -Detailed
# In der Hilfe sehen wir "-Computername ... This parameter does not rely on Windows Powershell Remoting..."
# Dafür haben wir vorhin die Firewall modifiziert.
$Computername = "Client02"
Get-Service -Computername $Computername | select Name,Status
# Und schon haben wir die Liste der Dienste, die auf dem anderen Rechner laufen.

# Jetzt schauen wir uns PSSession an:
Get-Command *-PSSession

Enter-PSSession -ComputerName $Computername
# und schwupp sind wir auf dem Remote System
# und zwar mit den Credentials, in denen wir uns auf dem aktuellen System 
# auch befinden. Das muss aber nicht so sein, man könnte auch eigene 
# Credentials angeben.
Get-Service | select Name,Status # Liefert die gleiche Liste wie der obere Befehl

Exit # verlässt die Session, die Session bleibt aber im Hintergrund aktiv.

Get-PSSession # listet jetzt die Session im Hintergrund auf.
Get-PSSession | Remove-PSSession # beendet alle offenen Sessions...

# Invoke-Command
help Invoke-Command -Examples

Invoke-Command -ComputerName $Computername -ScriptBlock { Get-Service|Select Name,Status }
# Um die Liste der Dienste des anderen Computers bei uns lokal zu speichern können
# wir so etwas schreiben:
Invoke-Command -ComputerName $Computername -ScriptBlock { Get-Service|Select Name,Status }|Out-File C:\scripts\InvokeService.txt

# CimSessions werden selten verwendet. Die spielen eine Rolle, wenn 
# man mehrere Cmdlets oder Module vorliegen hat, die explizit keine
# PSSession verwenden sollen. Eines dieser Module ist das DNS-Client Modul.

Get-DNSClientServerAddress -CimSession (New-CimSession -Computername $Computername)





