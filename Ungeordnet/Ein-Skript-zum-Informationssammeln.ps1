<#

    Building a User Inventory Script
    
    https://app.pluralsight.com/player?course=powershell-getting-started&author=michael-bender&name=powershell-getting-started-m5&clip=0

#>

# -------------------------------------
# Skripte in der Powershell ausführen
#   - Set-ExecutionPolicy
#   - Skripte in der CLI ausführen
# -------------------------------------

# 1. Set-ExecutionPolicy

# Per default ist auf allen Windows Computern das 
# ausführen von Powershell-Skripten untersagt.
# Wir können das aber einschalten. Dazu brauchen 
# wir eine administrative Powershell.
help Set-ExecutionPolicy -Full
Send-ExecutionPolicy Unrestricted

# Jetzt kann man bei geöffneter Powershell mit 
# .\Blubber.ps1 
# z.B. das Blubber-Powershellskript ausführen.

# -------------------------------------
# Powershell-ISE benutzen
#   - existierende Skripte ansehen
#   - neue Skripte erstellen
#   - Einführung in den Skriptbrowser
# -------------------------------------

# Wenn man die Powershell an die Task-Leiste gebunden hat
# kann man mit Rechtsklick nicht nur die Powershell 
# sondern auch die Admin-Powershell und die 
# ISE erreichen, ohne viel herumsuchen zu müssen.

# Merke: Die ISE muss man "als Administrator" starten, wenn man 
# Skripte schreiben möchte, die Admin-Rechte benötigen.

# Hinweis für Skriptinhalte :
# Wenn man einen Befehl über mehrere Zeilen aufteilen möchte, 
# kann man das mit dem Backtick und dem Pipe machen.
# Also ` und | .

# Nach beiden Symbolen nimmt die Powershell an, dass der Befehl oder 
# die Sequenz in der nächsten Zeile weitergeht.
# Dabei kannst du den Backtick fast beliebig platzieren. Das Pipe
# macht nur Sinn, wenn du tatsächlich gerade pipen möchtest...

# Beispielskript "Informationen zum letzten Neustart eines Rechners holen"
# Dateiname "Get-LastSystemReboot.ps1"

$Computername = Read-Host "Computernamen eingeben:"
Get-CimInstance -Classname Win32_OperatingSystem `
    -Computername $Computername |
    Select-Object -Property -OSName.LastBootupTime

# Ende

# -------------------------------------
# Einfache Elemente von Scripts
#   - Variablen setzen
#   - Parameter nutzen / festlegen
#   - if
#   - foreach
#   - Auf Eigenschaften zugreifen
# -------------------------------------

# Skript: "Get-ServiceStatus.ps1"
Param (
    Parameter( Mandatory = $true )
    [string] $Computername
)

$services = Get-Service -Computername $Computername
Foreach ($service in $services) {
    $serviceStatus = $service.Status
    $serviceDisplayName = $service.$serviceDisplayName

    Write-Output "$serviceDisplayName is $serviceStatus"
}
# Ende

# Kopiere das Skript in eine Powershell-Datei und öffne
# eine Powershell. Gehe dann in das Verzeichnis der Datei
# und probiere folgendes:
.\Get-ServiceStatus.ps1

# Als nächstes sollte dich das Skript nach einem Computernamen fragen,
# denn du hast keinen Parameter dazu angegeben und der Parameter
# ist nicht optional (mandatory).
# Dann kannst du einen Computernamen angeben und von diesem dann 
# die Liste aller Dienste mit ihrem Status erhalten.

# -------------------------------------
# Beispiel: 2 unterschiedliche Methoden um auf Eigenschaften zuzugreifen
# -------------------------------------

$operatingSystem = Get-CimInstance Win32_OperatingSystem | Select Caption
$operatingSystem2 = (Get-CimInstance Win32_OperatingSystem).Caption

$operatingSystem
$operatingSystem2

# Unterschied:
#   - Im ersten Fall wird ein Objekt zurückgeliefert. Als eine Art 
#     Liste von einem Objekt. Daher auch die tabellenartige Darstellung.
#     Die Ausgabe dieses Aufrufs eignet sich zur Weiterverarbeitung durch
#     weitere Pipes.
#   - Im zweiten Fall wird nur die Zeichenkette zurückgegeben.

# -------------------------------------
# Ein Remote Info Sammel-Skript bauen (Prozess)
#   1. Befehle in einer Powershell als Einzelbefehle ausprobieren
#   2. Befehle in die ISE kopieren und Variablen und Parameter einbauen
#   3. ggf. Logik für mehrere Computer einbauen
#   4. Keep it simple
# -------------------------------------

# Es ist sinnvoll, jedes neue Skript mit einem 
# Default-Template zu beginnen:

<# Template: Template.ps1 #>

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

# Variables

# Tasks as comments
#   - make Mahrveltown great again

<# Ende #>

# Endgültiges Skript: siehe "Get-Helpdesksupport.ps1".
