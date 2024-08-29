﻿#Requires -Version 5.0
#Requires -Modules PrintManagement

<#
.SYNOPSIS
    Removes the specified printer port from the computer

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
    https://github.com/scriptrunner/ActionPacks/tree/master/WinPrintManagement/Ports

.Parameter PortName
    [sr-en] Name of the printer port

.Parameter ComputerName
    [sr-en] Name of the computer from which remove the printer port
    
.Parameter AccessAccount
    [sr-en] User account that has permission to perform this action. If Credential is not specified, the current user account is used.
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$PortName,
    [string]$ComputerName,
    [PSCredential]$AccessAccount
)

Import-Module PrintManagement

$Script:Cim = $null
try{    
    if([System.String]::IsNullOrWhiteSpace($ComputerName)){
        $ComputerName = [System.Net.DNS]::GetHostByName('').HostName
    }          
    if($null -eq $AccessAccount){
        $Script:Cim = New-CimSession -ComputerName $ComputerName -ErrorAction Stop
    }
    else {
        $Script:Cim = New-CimSession -ComputerName $ComputerName -Credential $AccessAccount -ErrorAction Stop
    }
    
    $null = Remove-PrinterPort -CimSession $Script:Cim -ComputerName $ComputerName -Name $PortName -ErrorAction Stop  
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Printer port: $($PortName) removed from Computer: $($ComputerName)" 
    }
    else{
        Write-Output "Printer port: $($PortName) removed from Computer: $($ComputerName)"
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