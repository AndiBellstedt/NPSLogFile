@{
	# Script module or binary module file associated with this manifest
	RootModule = 'NPSLogFile.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.0.0'
	
	# ID used to uniquely identify this module
	GUID = '6dc7831e-141b-4d35-9868-10c023efe87b'
	
	# Author of this module
	Author = 'Andreas Bellstedt'
	
	# Company or vendor of this module
	CompanyName = ''
	
	# Copyright statement for this module
	Copyright = '(c) 2017 - Andreas Bellstedt. All rights reserved.'
	
	# Description of the functionality provided by this module
	Description = @'
Module for interpreting NPS Logfiles in PowerShell.

All cmdlets are build with 
- powershell regular verbs
- with pipeling availabilties where it is practical
- logging on verbose channel
'@
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '4.0'
	
	# Name of the Windows PowerShell host required by this module
	# PowerShellHostName = ''
	
	# Minimum version of the Windows PowerShell host required by this module
	# PowerShellHostVersion = ''
	
	# Minimum version of the .NET Framework required by this module
	# DotNetFrameworkVersion = '2.0'
	
	# Minimum version of the common language runtime (CLR) required by this module
	# CLRVersion = '2.0.50727'
	
	# Processor architecture (None, X86, Amd64, IA64) required by this module
	# ProcessorArchitecture = 'None'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	#RequiredModules = @(
	#	@{ ModuleName='PSFramework'; ModuleVersion='0.9.24.91' }
	#)
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @()
	
	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	# ScriptsToProcess = @()
	
	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @('xml\NPSLogFile.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @('xml\NPSLogFile.Format.ps1xml')
	
	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
	# NestedModules = @()
	
	# Functions to export from this module
	FunctionsToExport = 'Get-NPSLog'
	
	# Cmdlets to export from this module
	CmdletsToExport = ''
	
	# Variables to export from this module
	VariablesToExport = ''
	
	# Aliases to export from this module
	AliasesToExport = ''
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData           = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('NPS', 'NPSLog', 'NPSLogFile', 'LogFile', 'PowerShell', 'Automation', 'Logging')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/AndiBellstedt/NPSLogFile/blob/master/license'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/AndiBellstedt/NPSLogFile'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = @'
Hopefully some other people may benefit from my work and investigation.

Further release- and changenotes will be tracked in my github repo.
https://github.com/AndiBellstedt/NPSLogFile

'@

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI           = 'https://github.com/AndiBellstedt/NPSLogFile'
}