<#

    Dieses Skript ist eine Mitschrift aus
    https://app.pluralsight.com/player?course=powershell-getting-started&author=michael-bender&name=powershell-getting-started-m3&clip=3

    "Gathering Operating System and Hardware Information with PowerShell"

    Szenario: Der Benutzer beschwert sich darüber, dass sein 
              Computer langsam ist oder / und sich generell merkwürdig verhält.
#>

<#
    Wir schauen uns zunächst den zugeteilten Speicher an. Wenn viel
    RAM benutzt wird haben wir vielleicht schon die Ursache für das 
    Performanceproblem.
#>
# Wir suchen uns einen passenden Befehl. Wir gehen davon aus, dass 
# wir bei den Performance Countern fündig werden:
Get-Command *counter*

# Get-Counter sieht danach aus, als wenn das unser Favorit wäre.
# Probieren wirs aus:
Get-Counter

# Genauer: Wir suchen Speicher-Reports...
Get-Counter -listset *memory*

# Uuuh da gibt es etwas das "Memory" heisst. Mal genauer gucken:
Get-Counter -listset *memory* | where CounterSetName -eq "Memory"

# Wenn wir uns diese Ausgabe ansehen, dann sehen wir u.a. eine Property
# Paths. Diese wird nicht ganz dargestellt, scheint uns aber ganz interessant
# zu sein, also möchten wir gerne alle Positionen sehen:
Get-Counter -listset *memory* | where CounterSetName -eq "Memory" | select -Expand Paths

# Jetzt, wo wir die vollen Pfade angezeigt bekommen, können wir 
# mal abfragen. 
# Wir haben es aber erstmal besonders eilig, um einen Tippfehler zu demonstrieren:
Get-Counter "\memory\%committed bytes in use"

# Boom ! Das ist also eine Fehlermeldung, wenn der Counter unbekannt ist.
# Ich hoffe du hast vor allem auf die erste Zeile geachtet, die dir klar sagt,
# worum es geht.

# Jetzt korrigieren wir den Tippfehler:
Get-Counter "\memory\% committed bytes in use"

# Diese Counter sind schon echt nützliche Sachen. 
# Wenn du mal einfach eine Übersicht brauchst, ist "perfmon" das Tool deiner Wahl.
# Wenn du es nicht kennst, lass es dir gerne mal von SQL Server Junge zeigen.

# So, jetzt kennen wir den %-Wert des belegten Speichers. Wir möchten aber gerne
# die absolute Speichermenge haben.
# Probieren wir mal über CIM/WMI einem passenden Wert habhaft zu werden.
Get-CimInstance Win32_PhysicalMemory

# Wow, jetzt hab ich einen Kapazitäts-Wert also weiß ich wie groß der Speicher
# insgesamt ist. Das kann ich mit dem oberen Wert ausmultiplizieren und
# dann z.B. in GB umrechnen.
# Und das ist jetzt DEINE CHALLENGE! Wie würde das aussehen?

# ----------------------------

# Nächster Abschnitt: Freier Festplattenspeicher 

# Die Liste aller verfügbaren CIM-Klassen bekommt man über das CommandLet:
Get-CimClass

# Wir wollen etwas genauer bitte nur die Sachen, die mit der DISK zu tun haben:
Get-CimClass -ClassName *disk*

# Holen wir uns mal so ein WMI Objekt...
Get-WmiObject -Class Win32_LogicalDisk 

# Ui, und da sind sie schon die Daten die wir uns wünschen.
# Vielleicht noch nicht ganz so hübsch wie wir sie brauchen?
# CHALLENGE???

# ----------------------------

# Nächster Abschnitt: BIOS Version

# Vielleicht liegt ja das komische Verhalten daran, dass das BIOS zu alt ist.
# Mal gucken.
Get-CimClass -Class *BIOS*

# Ui
Get-WmiObject Win32_BIOS

# Mal gucken, was passiert, wenn wir statt Get-WmiObject Get-CimInstance verwenden...
Get-CimInstance Win32_BIOS

# Sieht gleich aus. Aha.
# Wir brauchen nicht alle Eigenschaften, also selektieren wir mal nur das Wichtigste:
Get-CimInstance Win32_BIOS | select Name,Version

# ----------------------------

# Nächster Abschnitt: Event Log

# Wir wollen nun mal gucken, ob im Event Log ein Neustart steht.
# Daher suchen wir uns zunächst mal einen passenden Befehl:
Get-Command *event*

# Get-EventLog sieht vielversprechend aus. Mal sehen.
# Dann brauchen wir wohl erstmal ein bisschen Hilfe:
help Get-EventLog

# Ok, sieht aus, als wenn es das tun würde, was wir brauchen.
# Es wäre aber schön, wenn wir noch ein paar Beispiele hätten:
help Get-EventLog -Examples

# Mit den Beispielen, speziell dem 9. Beispiel, sind wir schon 
# sehr nahe dem, was wir brauchen. 
# Basteln wir also unsere Variante:
Get-EventLog -log System -Newest 1000 | Where-Object EventId -EQ '1074' | Format-Table MachineName,Username,timegenerated -AutoSize

# ----------------------------

# Nächster Abschnitt: IP und DNS

# Wir alle kennen ipconfig und ipconfig /all...
# Jetzt wollen wir das aber mit der Powershell ausprobieren.
# Schauen wir zunächst, welche Befehle es da gibt:
Get-Command *IP*

# Wow sind das viele...
# Die Get-NetIP... Commandlets sehen insbesondere gut aus.
Get-NetIPAddress
Get-NetIPConfiguration

# Und wenn der Kunde ein Problem mit DNS hat?
Get-Command *DNS*
# Das waren wieder sehr viele. Wir sehen aber, dass es da was
# zu einem DNS Client gibt und das ist ja der Rechner.
Get-Command *DNSClient*

# Und wir bemühen die Hilfe um uns einen Einblick zu verschaffen:
help Get-DnsClient
# Und gucken:
Get-DnsClient
Get-DnsClientServerAddress
# Wir können sogar in den DNS Cache gucken:
Get-DnsClientCache

# ----------------------------

# Nächster Abschnitt: SMB Network Shares

# Zunächst schauen wir wieder, welche Befehle wir hier verwenden können.
Get-Command *smb*
# Und werden wiederholt von der Masse an Möglichkeiten überrannt.

help Get-SmbMapping -Examples

Get-SmbMapping

help New-SmbMapping
help New-SmbMapping -Examples

# CHALLENGE: Kannst du ein Netzwerklaufwerk mit Powershell einbinden?

# ----------------------------

# Nächster Abschnitt: Ping & TraceRoute

# Ping
Test-Connection 8.8.8.8
# TraceRoute
Test-Connection 8.8.8.8 -TraceRoute
# Ping + Port-Scan
Test-Connection -CommonTcpPort HTTP -Computer pluralsight.com

# ----------------------------

# Nächster Abschnitt: Registry

# Die Registry ist über ein System namens "Powershell-Provider" zugänglich.
# Die Provider sind ein Set von "Treibern", die bestimmte Bereiche praktisch als 
# Laufwerk zugänglich machen.
# Im Ergebnis kann man dann mit Set-Location navigieren und mit Get-Item und 
# Remove-Item und solcherlei CmdLets arbeiten.
help Get-PSProvider

# !Achtung!: Für Registry Zugriff benötigt man größtenteils Admin-Rechte!

# Wir schauen uns an, welche Provider installiert sind:
Get-PSProvider

# Wir gehen in den HKEY LOCAL MACHINE:
Set-Location HKLM:
Set-Location Software
Get-ChildItem # "dir"

# So setzt man einen Schlüssel:
# Set-ItemProperty -Path .\WiredBrainCoffee -Name PackageInstalled -Value 0




