<#
    E-Mail mit Powershell versenden - Beispiel
#>

$Absendeemailadresse = ""
$Empfaenger = ""
$Benutzername = ""
$Passwort = ""

$passwortVerschluesselt = ConvertTo-SecureString $Passwort -AsPlainText -Force

$anmeldung = New-Object System.Management.Automation.PSCredential ($Benutzername, $passwortVerschluesselt)

send-mailmessage -to $Empfaenge -from $Absendeemailadresse -subject "Test mail" `
   -UseSsl `
   -Body "Test" -Credential $anmeldung -SmtpServer smtp.web.de -Port 587
