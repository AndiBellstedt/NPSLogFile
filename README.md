![logo][]
# NPSLogFile - Getting insights from network policy services

A PowerShell module for parsing nps/ias log files.

Basically, the module only contains only one command:

    Get-NPSLog

This command takes single logfile, as well as Pipelineinput from Get-ChildItem (dir), parse trough the files and put out records as well formed objects.

## Usage
Basically, the intended usage is a construct of

    dir *logfolder* | Get-NPSLog | Export-CSV

or somthing like

    $logRecords = dir *logfolder* | Get-NPSLog
    $logRecords | ft
    $logRecords | ogv
    $logRecords | select-object * | Out-GridView

## Installation
Install the module from the PowerShell Gallery (systemwide):

    Install-Module NPSLogFile

or install it only for your user:

    Install-Module NPSLogFile -Scope CurrentUser

## Notes
All cmdlets are build with
- powershell regular verbs
- pipeling availabilties
- verbose and debug channel logging


[logo]: assets/NPSLogFile_128x128.png