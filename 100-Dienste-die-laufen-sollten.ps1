<#
    Mini-Projekt 1: Dienste, die laufen sollten

    In diesem ersten Abschnitt wollen wir die Powershell ein bisschen näher
    kennenlernen. Um das zu erreichen schauen wir uns das CommandLet
    Get-Service an, mit dem man als Administrator bereits eine Menge
    coole Sachen machen kann.

    Wir befassen uns in diesem Abschnitt mit Windows-Diensten. 
    Ein Teil einer jeden Wartung ist es, dass man nach dem Neustart eines
    Windows Servers mal nachsehen sollte, ob alle Dienste, die automatisch
    gestartet werden sollten, auch gestartet wurden.

    Das gibt uns einen großartigen Ansatzpunkt. 
#>

# Wenn du alle Dienste auf deinem Computer auflisten möchtest, dann kannst du einfach
# folgenden Befehl eingeben:
Get-Service

# Wow, das war einfach. Da wird man gleich mit einer dicken Liste vollgeklatscht.
# Naja, damit kann man so noch nicht viel anfangen, aber schon erstmal nett.
# In der Powershell sind übrigens Hilfeseiten integriert, die du wie folgt abrufen kannst,
# auch wenn du gerade keine Internet-Verbindung hast:
Get-Help Get-Service

# Um die Sache etwas ins Rollen zu bringen, wollen wir nun mal wissen, was man mit einem 
# solchen Dienst so alles machen kann. 
# Um das herauszufinden nehmen wir mal den ganz plumpen Ansatz.
# Als erstes schränken wir die Liste der Dienste auf nur einen einzigen ein.
Get-Service -DisplayName Anmeldedienst

# Dadurch bekommen wir nur diesen einen Dienst als Ergebnis, was schonmal klasse ist.
# Und dann fragen wir die Powershell, was für Methoden und Eigenschaften diese
# Dienste eigentlich haben.
Get-Service -DisplayName Anmeldedienst | Get-Member

# Jetzt denken wir an unser Mini-Projekt und sehen:
# 
# - Es gibt eine Methode "Start", die uns bestimmt dabei helfen kann, einen Dienst zu starten.
# 
# - Es gibt einen "StartType", der klingt danach, als wenn da drin steht, ob der Dienst
#   automatisch oder manuell oder gar nicht gestartet werden soll.
#
# - Und es gibt einen Status. Der ist mal "Stopped" und mal "Running", was danach 
#   aussieht, dass der wohl sagt, ob der Dienst läuft oder nicht.
#
# Diese Befehle helfen uns, uns mal ein bisschen genauer anzusehen, was da eigentlich
# drin steht, in den Properties welche die Objekte haben:

# Mit diesem Befehl kannst du dir eine einzelne oder mehrere Properties einzeln auswählen
Get-Service -DisplayName Anmeldedienst | ForEach-Object {
    Write-Host $_.StartType
}

# Powershell reduziert in verschiedenen Ansichten (wie oben bei Get-Service)
# den Detailgrad. Also verschiedene Informationen werden nicht anzeigt, obwohl 
# sie vorhanden sind. Das macht den Bildschirm zunächst übersichtlicher.
# (Z.B. gibt Get-Service eine Art Tabelle mit i.d.R. nur 3 Spalten aus)

# Wenn wir gerne mal alle Eigenschaften sehen wollen, inkl. ihrer Inhalte,
# dann machen wir das so:  
Get-Service -DisplayName Anmeldedienst | Format-List -Property *