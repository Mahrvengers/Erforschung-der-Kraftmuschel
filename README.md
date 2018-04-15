# Erforschung der Kraftmuschel mit den Mahrvengers!!

Willkommen bei der "Erforschung der Kraftmuschel" mit den Mahrvengers!
Dieses Repository sind unsere strukturierten Notizen, während wir 
die Powershell immer besser kennen lernen. 

Um die Skripte aus diesem Verzeichnis auf deinen Rechner zu bekommen, 
benötigst du zunächst git. Das ist ein Versionskontrollsystem, das
u.a. dafür sorgen kann, dass du immer die aktuellste Version dieser
Skripte auf deine Platte bekommst. 

## Wie installiere ich git?

Auf einem frischen Windows-Rechner geht das am Einfachsten mit chocolatey.

  - https://chocolatey.org 

Chocolatey ist eine Art apt-get für Windows. Wenn du es entsprechend
der Anleitung installiert hast, dann kannst du viele unterschiedliche 
Anwendungen mit einem einfachen Aufruf in deiner administrativen Powershell
installieren. 

Um git mit einem zusätzlichen UI Tool zu installieren (falls du nicht so 
der Kommandozeilen-Mensch bist) kannst du folgendes eingeben:

```
choco install git tortoisegit 
```

Git ist dabei eine aktuelle Version von git. 
Und TortoiseGit ist ein visuelles Tool mit einer Explorer-Integration.

## Wie bekomme ich das Repository auf meine eigene Platte?

Zunächst benötigst du ein lokales Verzeichnis bei dir auf dem Rechner. 
Ich mach mir oft ein Verzeichnis C:\Projekte . Mach dir dazu eine Powershell
auf und gebe folgende Befehle ein:

```
cd C:\
mkdir Projekte
cd Projekte
```

Es ist wichtig zuerst das Verzeichnis erstellt und da hinein gewechselt zu haben, 
weil git in diesem aktuellen Arbeitsverzeichnis die Daten ablegen wird.
Wenn du also unter C:\Windows\System32 bist, dann würde dort ein neues Unterverzeichnis
erstellt werden - und das will in der Regel niemand :).

Dann bist du also im Verzeichnis `C:\Projekte\` und gibst folgenden git-Befehl ein:

```
git clone https://github.com/Mahrvengers/Erforschung-der-Kraftmuschel.git
```

Git ruft alle Dateien ab und speichert sie dort in einem neuen Ordner `Erforschung-der-Kraftmuschel`. 

## Wie bekomme ich Aktualisierungen die auf GitHub verfügbar sind?

Wechsel in dein Projektverzeichnis mit einer Powershell. Also z.B. 
```
cd C:\Projekte\Erforschung-der-Kraftmuschel
```

Nun gibst du einfach den Befehl ein: 
```
git pull
```

... und schon werden die neusten Neuerungen auf deine Festplatte geladen.

(Es ist auch möglich eigene Änderungen auf github hochzuladen und sie allen
anderen damit zur Verfügung zu stellen. Aber dazu später mehr.)

## Welche Powershell-Version habe ich?

Jetzt möchtest du natürlich zunächst wissen, welche Powershell-Version du eigentlich 
hast. Schließlich gibt es eine Menge: 
Powershell 1.1, 2, 3, 4, 5 und 5.1 sowie "6" aka "Powershell Core", welche abweichend
von den vorgenannten Powershells cross platform interaction ermöglicht.

```
$PSVersionTable
```

## Wie gehe ich weiter vor?

Wir haben die Powershell-Dateien nach dem Muster xyz-Bezeichnung.ps1 benannt, wobei xyz
immer eine dreistellige Zahl ist. Wenn du Datei für Datei durchgehst, dann gehst du 
in der gleichen Reihenfolge vor, wie wir. 

In jeder Powershell-Datei sind umfangreiche Kommentare. Öffne sie einfach in 
der Powershell ISE und führe sie Zeile für Zeile aus, um mehr zu erfahren.
Gefährliche Befehle sind extra markiert :).

Ein paar Dateien sind auch im Ordner "Ungeordnet". Da wirft SQL Server Junge seine
Skripte rein, die er vorstellen möchte. Die werden später geordnet.

## coole Links

  - https://blogs.technet.microsoft.com/stephap/2012/04/23/building-forms-with-powershell-part-1-the-form/
