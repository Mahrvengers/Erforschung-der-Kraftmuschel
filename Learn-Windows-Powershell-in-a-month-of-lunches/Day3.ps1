<#
    Day 3 - Using the help system
#>

# Get help for a command
Help Get-Service

# Update the help files
Update-Help
Update-Help -Force

# Find help by a part of a command
Help *log*
Help *event*

help html

get-command -noun Html
get-command -noun file,printer

Get-Command -noun Process
Get-Command -Verb Write -Noun EventLog

Help Out-File -Full
Help Out-File -parameter Width

Get-Alias 
ps -c server1
get-command -noun object
help about_arrays

help *array*