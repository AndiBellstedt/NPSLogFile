function Get-NPSLog {
    <#
    .Synopsis
       Get NPS logfiles in various formats.

    .DESCRIPTION
       Get NPS logfiles and put it into readable powershell objects.
       All available logfile formats from NPS are supportet by parameter 'Format'.

    .INPUTS
       Cmdlet accept string values. Pipelineinput has to be the path to a logfile

    .OUTPUTS
       Cmdlet outputs a custom psobject with own typename in namespace NPS.LogFile

    .NOTES
       Version:     2.0.0.0
       Author:      Andreas Bellstedt
       History:     06.08.2017 - First Version, only DTS format is supported.
                    13.08.2017 - Change/enhance filter method
                    20.08.2017 - Add runspace processing for faster support of larger files
                                 Clearing up the function and building a module
                    22.08.2017 - remove not needed code and outcommended test stuff
                    27.08.2017 - Change processing of file content, using type system to speed up record processing
                                 Add name of the logfile as property to output item
                                 Finished funtion for reading DTS logs.
                                 Start to work on IAS format support.
                    31.08.2017 - Start working on IDBC format support
                    01.09.2017 - All formats are working.

       Helpfull sources
       ----------------
       Interpret the different formats:
       DTS format --> https://technet.microsoft.com/en-us/library/cc771748(v=ws.10).aspx#Anchor_1
       IAS format --> https://technet.microsoft.com/de-de/library/dd197432(v=ws.10).aspx
       ODBC format --> https://technet.microsoft.com/en-us/library/cc771748(v=ws.10).aspx
       RADIUS Packet format --> https://technet.microsoft.com/en-us/library/cc958030.aspx
       IANA defintion --> http://www.iana.org/assignments/radius-types/radius-types.xhtml
       Health Validator Records interpretierne --> https://technet.microsoft.com/en-us/library/cc730901(v=ws.10).aspx

       Existing script MS NPS/RADIUS Logs Interpreter:
       https://gallery.technet.microsoft.com/MS-NPSRADIUS-Logs-b68af449

       Runspaces:
       https://gist.github.com/proxb/803fee30f0df244fd850
       https://learn-powershell.net/2016/02/14/another-way-to-get-output-from-a-powershell-runspace/
       https://learn-powershell.net/2016/11/28/yet-another-way-to-get-output-from-a-runspace-reflection-edition/
       https://github.com/psconfeu/2016s

    .LINK
       https://github.com/AndiBellstedt/

    .PARAMETER Path
        The logfile to gather data from.

    .PARAMETER Format
        The format of the nps logfile.
        Default is DTS.

    .PARAMETER Filter
        Allow to filter on specific events in the NPS log.

    .PARAMETER Encoding
        Specifies the file encoding of the logfile.
        Default is UTF8

    .PARAMETER Confirm
        If this switch is enabled, you will be prompted for confirmation before executing any operations that change state.

    .PARAMETER WhatIf
        If this switch is enabled, no actions are performed but informational messages will be displayed that explain what would happen if the command were to run.

    .EXAMPLE
       Get-NPSLog C:\Windows\System32\LogFiles\IN170901.log
       By default the cmdlet will get the entries from the logfile in DTS format with UTF8 encoding.

    .EXAMPLE
       Get-NPSLog -Path C:\Windows\System32\LogFiles\IN170901.log -Format DTS -Encoding UTF8
       This is an example of the even more specific call for the cmdlet. From the functional point, is it the same from Example 1.

    .EXAMPLE
       Get-NPSLog -Path C:\Windows\System32\LogFiles\IN170901.log -Format IAS -Encoding UTF8
       This will get the entries from the logfile in IAS format with UTF8 encoding.

    .EXAMPLE
       Get-NPSLog -Path C:\Windows\System32\LogFiles\IN170901.log -Format ODBC -Encoding UTF8
       This will get the entries from the logfile in ODBC format with UTF8 encoding.

    .EXAMPLE
       Get-NPSLog -Path C:\Windows\System32\LogFiles\IN170901.log -Format DTS -Encoding UTF8 -Filter Access-Reject, Access-Accept
       This will return only "reject" and "accept" entries from the logfile.
       Adding filter parameter will slightly speed up the parsing of larger files.

    .EXAMPLE
       Get-ChildItem C:\Windows\System32\LogFiles\IN*.log | Get-NPSLog
       Parse all logfiles from "C:\Windows\System32\LogFiles". The cmdlet assumes the files in DTS format with UTF8 encoding, because the is the default.

    #>
    [CmdletBinding(DefaultParameterSetName = 'DefaultParameterSet',
        SupportsShouldProcess = $true,
        PositionalBinding = $true,
        ConfirmImpact = 'Low')]
    Param(
        [Parameter(Mandatory = $true,
            ParameterSetName = 'DefaultParameterSet',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [Alias('LogFile', 'File', 'FullName')]
        [String[]]
        $Path,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'DefaultParameterSet',
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('DTS', 'IAS', 'ODBC')]
        [String]
        $Format = 'DTS',

        [Parameter(Mandatory = $false,
            ParameterSetName = 'DefaultParameterSet',
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false)]
        [ValidateSet('Access-Request', 'Access-Accept', 'Access-Reject', 'Accounting-Request', 'Accounting-Response', 'Accounting-Status (now Interim Accounting)', 'Password-Request', 'Password-Ack', 'Password-Reject', 'Accounting-Message', 'Access-Challenge', 'Status-Server (experimental)', 'Status-Client (experimental)', 'Resource-Free-Request', 'Resource-Free-Response', 'Resource-Query-Request', 'Resource-Query-Response', 'Alternate-Resource-Reclaim-Request', 'NAS-Reboot-Request', 'NAS-Reboot-Response', 'Next-Passcode', 'New-Pin', 'Terminate-Session', 'Password-Expired', 'Event-Request', 'Event-Response', 'Disconnect-Request', 'Disconnect-ACK', 'Disconnect-NAK', 'CoA-Request', 'CoA-ACK', 'CoA-NAK', 'Unassigned', 'IP-Address-Allocate', 'IP-Address-Release', 'Protocol-Error', 'Experimental Use', 'Reserved')]
        [String[]]
        $Filter,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'DefaultParameterSet',
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Default', 'ASCII', 'UTF8', 'UTF7', 'UTF32', 'Unicode', 'BigEndianUnicode')]
        [String]
        $Encoding = 'UTF8'
    )
    Begin {
        # int local variables
        [NPS.LogFile.Cache]::Data.Clear()
        $TypeName = "$($BaseType).$($Format)"

        # # runspace related stuff
        [System.Collections.ArrayList]$Runspaces = @()
        [System.Management.Automation.Runspaces.RunspacePool]$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, [int]($env:NUMBER_OF_PROCESSORS))
        $RunspacePool.ApartmentState = "MTA"
        $RunspacePool.Open()

        # ScriptBlock for interpreting entries from logfiles
        switch ($Format) {
            'DTS' {
                [System.Management.Automation.ScriptBlock]$ScriptBlock = {
                    Param(
                        $InputObject,
                        [String[]]$Filter,
                        [String]$FilePath
                    )
                    foreach ($Item in $InputObject) {
                        if ($Filter) {
                            $process = $false
                            foreach ($FilterIdItem in ([NPS.LogFile.Lookup]::FilterPacketTypes[$Filter])) {
                                if ($item -like "*>$($FilterIdItem)</Packet-Type>*") {
                                    $process = $true
                                }
                            }
                            if (-not $process) { continue }
                        }
                        [xml]$LogEntry = $Item

                        New-Variable -Name PropertyHash -Scope Script -Force
                        New-Variable -Name PropertyList -Scope Script -Force
                        $PropertyList = $LogEntry.Event.psobject.properties.name
                        $PropertyHash = ([string]::Join(",", $PropertyList)).GetHashCode()
                        if (-not [NPS.LogFile.Cache]::Data[$PropertyHash]) { [NPS.LogFile.Cache]::Data.Add($PropertyHash, $PropertyList) }

                        $Hash = @{}
                        $Hash.Add("Event", $LogEntry.Event)
                        $Hash.Add("LogFile", $FilePath)
                        $Hash.Add("PropertyListHash", $PropertyHash)

                        New-Object psobject -Property $hash
                    }
                }
            }

            'IAS' {
                [System.Management.Automation.ScriptBlock]$ScriptBlock = {
                    Param(
                        $InputObject,
                        [String[]]$Filter,
                        [String]$FilePath
                    )
                    foreach ($Item in $InputObject) {
                        if ($Filter) {
                            $process = $false
                            foreach ($FilterIdItem in ([NPS.LogFile.Lookup]::FilterPacketTypes[$Filter])) {
                                if ($item -like "*,4136,$($FilterIdItem),*") {
                                    $process = $true
                                }
                            }
                            if (-not $process) { continue }
                        }

                        $DataTable = $Item -split ','
                        $Hash = [ordered]@{}
                        #First 6 positions are Header
                        $Hash.Add("NASIPAddress", $DataTable[0]) #The IP address of the network access server (NAS) that is sending the request.
                        $Hash.Add("UserName"    , $DataTable[1]) #The user name that is requesting access.
                        $Hash.Add("RecordDate"  , $DataTable[2]) #The date that the log is written.
                        $Hash.Add("RecordTime"  , $DataTable[3]) #The time that the log is written.
                        $Hash.Add("ServiceName" , $DataTable[4]) #The name of the service that is running on the RADIUS server.
                        $Hash.Add("ComputerName", $DataTable[5]) #The name of the RADIUS server.

                        $i = 6
                        do {
                            if ($DataTable[$i]) {
                                $AttributeType = [NPS.LogFile.Lookup]::IasAttributeTypes["$($DataTable[$i])"]

                                if ($AttributeType.GetType().Name -match 'Hashtable') {
                                    $AttributeName = $AttributeType.Name -replace '-|_'
                                    $AttributeValue = $AttributeType.Enumerator["$($DataTable[$i + 1])"]
                                    if (-not $AttributeValue) { $AttributeValue = $DataTable[$i + 1] } #Fallback if value from log is not in hashtable enumerator
                                } else {
                                    $AttributeName = $AttributeType -replace '-|_'
                                    $AttributeValue = [String]($DataTable[$i + 1])
                                }
                                Write-Verbose "$($AttributeName):$($AttributeValue)"
                                $Hash.Add($AttributeName, $AttributeValue)
                            }
                            $i = $i + 2
                        } while ($i -le $DataTable.count)

                        $Hash.Add("LogFile", $FilePath)
                        New-Object -TypeName PSObject -Property $Hash
                    }
                }
            }

            'ODBC' {
                [System.Management.Automation.ScriptBlock]$ScriptBlock = {
                    Param(
                        $InputObject,
                        [String[]]$Filter,
                        [String]$FilePath
                    )
                    foreach ($Item in $InputObject) {
                        if ($Filter) {
                            $process = $false
                            foreach ($FilterIdItem in ([NPS.LogFile.Lookup]::FilterPacketTypes[$Filter])) {
                                if ($item -like "*,4136,$($FilterIdItem),*") {
                                    $process = $true
                                }
                            }
                            if (-not $process) { continue }
                        }

                        $DataTable = $Item -split ','
                        $Hash = @{}
                        $Hash.Add("Event", $DataTable)
                        $Hash.Add("LogFile", $FilePath)

                        New-Object -TypeName PSObject -Property $Hash
                    }
                }
            }

            Default { Write-Error "Mistake by Developer"}
        }
    }

    Process {
        # Start getting data from files
        foreach ($FilePath in $Path) {
            if (Test-Path -Path $FilePath) {
                Write-Verbose "Open ""$($FilePath)"" from disk. (Encoding $($Encoding))"

                $File = [System.IO.File]::Open($FilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
                $FileContent = [System.IO.StreamReader]::new($File, [System.Text.Encoding]::$Encoding)

                if (($File.Length / 1MB) -gt 10) { [int]$BatchSize = 2000 } else { [int]$BatchSize = 200 }
                $i = 0
                $LineBuffer = New-object System.object[]($BatchSize) # create an array with buffer size
                do {
                    $process = $true
                    $i = $i + 1
                    $FileLine = $FileContent.ReadLine()
                    if ($FileLine) { $LineBuffer[$i - 1] = $FileLine } else { $i = $i - 1 }

                    if ( (($i % $BatchSize) -eq 0) -or ($FileLine -eq $null) -or $FileContent.EndOfStream ) {
                        $PowerShell = [PowerShell]::Create()
                        [void]$PowerShell.AddScript($scriptblock)
                        [void]$PowerShell.AddArgument($LineBuffer[0..($i - 1)])
                        [void]$PowerShell.AddArgument($Filter)
                        [void]$PowerShell.AddArgument($FilePath)
                        $PowerShell.RunspacePool = $RunspacePool
                        [void]$Runspaces.Add(
                            (New-Object -TypeName PSObject -Property @{
                                    Status     = $PowerShell.BeginInvoke()
                                    PowerShell = $PowerShell
                                    FilePath   = $FilePath
                                }
                            )
                        )
                        Write-Debug "Buffer is filled (size:$i). Creating runspace for log entries (count:$($Runspaces.count))."
                        $LineBuffer = New-object System.object[]($BatchSize) # create an array with buffer size
                        $i = 0
                    }
                } while ($FileContent.EndOfStream -eq $false)

                Write-Debug "Finished reading content from $FilePath"
                $FileContent.Close()
                $File.Close()
            }
        }

        Write-Debug "Waiting for finish $($Runspaces.count) datastream runspace(s)"
        $TotalCount = $Runspaces.count
        $Finished = 0
        While ($Runspaces) {
            $RunspacesToRemove = @()
            Foreach ($Runspace in $Runspaces) {
                If ($Runspace.Status.IsCompleted) {
                    $Finished = $Finished + 1
                    Write-Progress -Activity "Working on $($Runspace.FilePath)" -Status "Finishing datastreams: $Finished of $($TotalCount)" -PercentComplete ($Finished / $TotalCount * 100)
                    Write-Debug "Runspace $($Runspace.PowerShell.InstanceId) finished"

                    $Results = $Runspace.PowerShell.EndInvoke($Runspace.Status)
                    $Runspace.PowerShell.Dispose()
                    $RunspacesToRemove += $Runspace

                    foreach ($ResultItem in $Results) {
                        $ResultItem.pstypenames.Insert(0, $BaseType)
                        $ResultItem.pstypenames.Insert(0, $TypeName)
                        if ($Format -like "DTS") {
                            $ResultItem.pstypenames.Insert(0, "$($TypeName).$($ResultItem.PropertyListHash)")
                            $ResultItem.pstypenames.Insert(0, "$($TypeName).$( [NPS.LogFile.Lookup]::PacketTypes[([int]$ResultItem.event.'Packet-Type'.'#text')] -replace '-|_' )")
                        }

                        [psobject]::new($ResultItem)
                    }
                }
            }
            foreach ($RunspaceToRemove in $RunspacesToRemove) {
                Write-Debug "Runspace $($RunspaceToRemove.PowerShell.InstanceId) removed"
                $Runspaces.Remove($RunspaceToRemove)
            }
            Remove-Variable RunspacesToRemove
        }

    }

    End {
        If ([NPS.LogFile.Cache]::Data) {
            switch ($Format) {
                'DTS' {
                    foreach ($DataItem in [NPS.LogFile.Cache]::Data.Keys) {
                        $PropertyList = [NPS.LogFile.Cache]::Data[$DataItem]
                        foreach ($Property in $PropertyList) {
                            Update-TypeData -TypeName "$($TypeName).$($DataItem)" -MemberType ScriptProperty -Force -MemberName ($Property -replace '-|_') -Value ([scriptblock]::Create( "`$this.Event.'$Property'.'#text'" ))
                        }
                    }
                    [NPS.LogFile.Cache]::Data.Clear()
                }

                'IAS' {}

                'ODBC' {}

                Default { Write-Error "Mistake by Developer" }
            }
        }
        $RunspacePool.Close()
        $RunspacePool.Dispose()
        Remove-Variable RunspacePool, Runspaces
    }
}