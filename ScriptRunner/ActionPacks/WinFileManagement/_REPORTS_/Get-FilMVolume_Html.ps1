﻿#Requires -Version 5.0

<#
.SYNOPSIS
    Generates a report with all volume objects

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
    © ScriptRunner Software GmbH

.COMPONENT
    Requires Library Script ReportLibrary from the Action Pack Reporting\_LIB_

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/WinFileManagement/_REPORTS_

.Parameter ComputerName
    [sr-en] Name of the computer from which to retrieve the volume object informations. If Computername is not specified, the current computer is used.
    
.Parameter AccessAccount
    [sr-en] User account that has permission to perform this action. If Credential is not specified, the current user account is used.
#>

[CmdLetBinding()]
Param(    
    [string]$ComputerName,
    [PSCredential]$AccessAccount
)

$Script:Cim=$null
$Script:output = @()

try{
    [string[]]$Properties = @('DriveLetter','DriveType','FileSystemType','Size','SizeRemaining','AllocationUnitSize')
    
    if([System.String]::IsNullOrWhiteSpace($ComputerName)){
        $ComputerName = [System.Net.DNS]::GetHostByName('').HostName
    }          
    if($null -eq $AccessAccount){
        $Script:Cim = New-CimSession -ComputerName $ComputerName -ErrorAction Stop
    }
    else {
        $Script:Cim = New-CimSession -ComputerName $ComputerName -Credential $AccessAccount -ErrorAction Stop
    }        
    Get-Volume -CimSession $Script:Cim -ErrorAction Stop | Select-Object $Properties | ForEach-Object {
            $Script:output += New-Object PSObject -Property ([ordered] @{ 
                DriveLetter = $_.DriveLetter
                DriveType = $_.DriveType
                'Size (MB)' = ([math]::round($_.Size/1MB, 3))
                'SizeRemaining (MB)' = ([math]::round($_.SizeRemaining/1MB, 3))
                FileSystemType = $_.FileSystemType
                AllocationUnitSize = $_.AllocationUnitSize
            })
    }
    
    ConvertTo-ResultHtml -Result $Script:output
}
catch{
    throw
}
finally{
    if($null -ne $Script:Cim){
        Remove-CimSession $Script:Cim 
    }
}