![logo][]
# NPSLogFile - Getting insights from network policy services
| Plattform | Information |
|- |-|-|
| PowerShell gallery | [![PowerShell Gallery](https://img.shields.io/powershellgallery/v/NPSLogFile?label=psgallery)](https://www.powershellgallery.com/packages/NPSLogFile) [![PowerShell Gallery](https://img.shields.io/powershellgallery/p/NPSLogFile)](https://www.powershellgallery.com/packages/NPSLogFile) [![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/NPSLogFile?style=plastic)](https://www.powershellgallery.com/packages/NPSLogFile) |
| GitHub  | [![GitHub release](https://img.shields.io/github/release/AndiBellstedt/NPSLogFile.svg)](https://github.com/AndiBellstedt/NPSLogFile/releases/latest) ![GitHub](https://img.shields.io/github/license/AndiBellstedt/NPSLogFile?style=plastic) <br> ![GitHub issues](https://img.shields.io/github/issues-raw/AndiBellstedt/NPSLogFile?style=plastic) <br> ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/AndiBellstedt/NPSLogFile/master?label=last%20commit%3A%20master&style=plastic) <br> ![GitHub last commit (branch)](https://img.shields.io/github/last-commit/AndiBellstedt/NPSLogFile/development?label=last%20commit%3A%20development&style=plastic) |
<br>

## Description
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