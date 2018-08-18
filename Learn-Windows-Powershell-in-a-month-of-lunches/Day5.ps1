<#

    Day 5 - Working with providers

#>

<#
    1. In the Registry, go to HKEY_CURRENT_USER\software\microsoft\Windows -currentVersion\explorer. Locate the "Advanced" key, and set its DontPrettyPath property to 1.
    2. Create a new directory called C:\Labs
    3. Create a zero-length file named C:\Labs\Test.txt (Use New-Item)
    4. Is it possible to use Set-Item to change the contents of C:\Labs\Test.txt to TESTING? Or do you get an error? If you get an error, why?
    5. Using the Environment provider, display the value of the system environment variable %TEMP%
    6. What are the differences between the -Filter, -Include, and -Exclude parameters of Get-ChildItem?
#>