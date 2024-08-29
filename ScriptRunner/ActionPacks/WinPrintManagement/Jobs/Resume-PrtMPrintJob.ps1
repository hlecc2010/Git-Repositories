﻿#Requires -Version 5.0
#Requires -Modules PrintManagement

<#
.SYNOPSIS
    Resumes a suspended print job

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
    https://github.com/scriptrunner/ActionPacks/tree/master/WinPrintManagement/Jobs

.Parameter PrinterName
    [sr-en] Name of the printer on which to resume the print job

.Parameter JobID
    [sr-en] ID of the print job to resume on the specified printer

.Parameter ComputerName
    [sr-en] Name of the computer on which to resume the print job
    
.Parameter AccessAccount
    [sr-en] User account that has permission to perform this action. If Credential is not specified, the current user account is used.
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$PrinterName,
    [Parameter(Mandatory = $true)]
    [int]$JobID,
    [string]$ComputerName,
    [PSCredential]$AccessAccount
)

Import-Module PrintManagement

$Script:Cim=$null
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

    $null = Resume-PrintJob -CimSession $Script:Cim -ComputerName $ComputerName -PrinterName $PrinterName -ID $JobID -ErrorAction Stop
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Resumed print job: $($JobID) from printer: $($PrinterName) on Computer: $($ComputerName)"
    }
    else{
        Write-Output "Resumed print job: $($JobID) from printer: $($PrinterName) on Computer: $($ComputerName)" 
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