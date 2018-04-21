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

# ----------------------------

# Nächster Abschnitt: Dateien und Drucker

help Get-ChildItem
help Get-ChildItem -Examples

# Rekursive Dateiauflistung
Get-ChildItem -Path C: -Recurse
# Nur Textdateien 
Get-ChildItem -Path C: -Include *.txt -Recurse 

# Wie funktioniert kopieren eigentlich?
Get-Command *copy*

help Copy-Item
help Copy-Item -Examples

# Beispiel
Copy-Item M:\Source -Destination M:\Backup -Recurse -Verbose
# -Verbose sorgt dafür, dass alle Teilschritte ausgegeben werden.

# Ein Verzeichnis / eine Datei verschieben
Move-Item C:\Backgrounds -Destination C:\MovedFolder -Verbose

# Ein Verzeichnis umbenennen
Rename-Item C:\MovedFolder -NewName C:\RenamedFolder

# Zugriffsrechte ermitteln (Windows, der "exe-Weg")
icacls.exe | more

icacls.exe C:\DesktopBackgrounds

# "Es gibt keinen einfachen Weg Zugriffsrechte auf Dateien mit der Powershell zu ermitteln"

#
# Jetzt: Drucker
#
Get-Command *printer*

# Lokale Drucker
Get-Printer

# Sagen wir, du weißt, dass alle Drucker auf DC01 registriert sind.
# Dann liste doch die auf... :)
Get-Printer -ComputerName DC01

# Wenn wir mehr Details brauchen, können wir ein Format-List anhängen.
# Entweder als Format-List oder als fl (Kurzform)
Get-Printer -ComputerName DC01 | Format-List

# Es gibt da eine Property "ShareName". Das ist der Name, den wir 
# nutzen um den Drucker lokal einzuhängen.
# Wie sieht der Befehl aus?
help add-printer -Examples

Add-Printer -ConnectionName \\DC01\HPLaserJetMegaPrinter

# Und schon haben wir einen weiteren Drucker installiert:
Get-Printer

# Jetzt mögen wir ihn doch nicht und wollen ihn löschen:
Remove-Printer -Name "Some printer in our printer list"

# ----------------------------

# Nächster Abschnitt: Active Directory

# Commandlets für AD:
Get-ADUser
Search-ADAccount
Get-ADComputer
Get-ADGroup
Get-ADGroupMember
Add-ADGroupMember

# Benutzerinformationen nachschlagen
help *user*
help Get-AdUser 
help Get-AdUser -Examples

Get-AdUser -Identity GlenJohn -Properties *

# Suchen aller AD Benutzer, die sich ausgesperrt haben
Search-ADAccount -LockedOut | Select Name

# Suchen aller AD Benutzer, die deaktiviert sind
Search-ADAccount -AccountDisabled | Select Name

# Alle Computer in der Domäne auflisten
Get-ADComputer -Filter *

# Ein Computer angucken
Get-ADComputer -Identity Client02 
# Alle Properties anzeigen
Get-ADComputer -Identity Client02 -Properties * | more

# AD Gruppen:
Get-Command *group*
help Get-ADGroup
help Get-ADGroup -Examples

# Also z.B. Informationen für alle Administatoren auflisten:
Get-ADGroup -Identity administrators

# Alle Gruppen auflisten:
Get-ADGroup -Filter * | more

# Gruppe nach Namensstück suchen:
Get-ADGroup -Filter * | Where Name -like "*admin*"

# Das geht auch mit dem Filter:
Get-ADGroup -Filter {Name -like "*admin*"}

# Alle Mitglieder der Gruppe Administratoren auflisten
Get-ADGroupMember -Identity "Administrators" | Select Name

# Ein neues Mitglied hinzufügen
Add-ADGroupMember -Identity "Administrators" -Members SqlServerJungeAccountName 

# Alle Benutzer finden, die im Marketing arbeiten und im Seattle Branch arbeiten
Get-ADUser -Filter * -Properties * | Get-Member | more

Get-ADUser -Property Name,City,Department -filter {Department -eq "Marketing" -and City -eq "Seattle"} | Format-Table SamAccountName,City,Department -AutoSize

# Und zum Boss schicken:
Get-ADUser -Property Name,City,Department -filter {Department -eq "Marketing" -and City -eq "Seattle"} | Format-Table SamAccountName,City,Department -AutoSize > SeattleMarketing.txt





