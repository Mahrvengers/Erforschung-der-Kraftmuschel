<#
    Day 4 : Running commands
#>

Get-Alias -Definition "Get-Service"
Help gsv

( Get-Command Get-EventLog | Select -ExpandProperty Parameters ).ComputerName.Aliases

Get-EventLog -LogName Security -Cn SORGFALT -Newest 10

Get-ChildItem C:\Users

Get-ChildItem -Path C:\Users

Move C:\file.txt C:\Users\Entwickler\

Move -Path C:\file.txt -Destination C:\Users\Entwickler\

Show-Command Get-EventLog

<#
  Aufgaben

  - Display a list of running processes
  - Display the 100 most recent entries from the application event log.
  - Display a list of all commands that are f the cmdlet type
  - Display a list of all aliases
  - Make a new alias, so you can run np to launch notepad from a Powershell prompt
  - Display a list of services that begin with the letter M. Again, read the help for the necessary command -- and don't forget that the asterisk (*) is a near-universal wildcard in PowerShell. Note that this will work only on Windows operating systems.
  - Display a list of all Windows Firewall rules. You'll need to use Help or Get-Command to discover the necessary cmdlet. Again, this will work only on Windows operating systems.
  - Display a list only of inbound Windows Firewall rules. You can use the same cmdlet as in the previous task, but you'll need to read is help to discover the necessary parameter and its allowable values. Once more, Windows operating systems only for this one. 
#>


