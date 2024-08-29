﻿#Requires -Version 5.0
#Requires -Modules PrintManagement

<#
.SYNOPSIS
    Gets all printer drivers from the computer

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
    © ScriptRunner Software GmbH

.COMPONENT
    Requires Module PrintManagement

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/WinPrintManagement/Drivers

.Parameter ComputerName
    [sr-en] Name of the computer from which to retrieve the printer drivers
    
.Parameter AccessAccount
    [sr-en] User account that has permission to perform this action. If Credential is not specified, the current user account is used.

.Parameter Properties
    [sr-en] List of properties to expand. Use * for all properties
#>

[CmdLetBinding()]
Param(
    [string]$ComputerName,
    [PSCredential]$AccessAccount,
    [ValidateSet('*','Name','Description','InfPath','ConfigFile', 'MajorVersion','PrinterEnvironment','PrintProcessor')]
    [string[]]$Properties = @('Name','Description','InfPath','ConfigFile', 'MajorVersion','PrinterEnvironment','PrintProcessor')
)

Import-Module PrintManagement

$Script:Cim = $null
try{
    if($Properties -contains '*'){
        $Properties = @('*')
    }
    if([System.string]::IsNullOrWhiteSpace($ComputerName)){
        $ComputerName = [System.Net.DNS]::GetHostByName('').HostName
    }          
    if($null -eq $AccessAccount){
        $Script:Cim = New-CimSession -ComputerName $ComputerName -ErrorAction Stop
    }
    else {
        $Script:Cim = New-CimSession -ComputerName $ComputerName -Credential $AccessAccount
    }

    $drivers = Get-PrinterDriver -CimSession $Script:Cim -ComputerName $ComputerName -ErrorAction Stop  `
                                    | Select-Object $Properties | Sort-Object Name    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $drivers 
    }
    else{
        Write-Output $drivers
    }
}
catch{
    throw
}
finally{
    if($null -ne $Script:Cim){
        Remove-CimSession $Script:Cim 
    }
}