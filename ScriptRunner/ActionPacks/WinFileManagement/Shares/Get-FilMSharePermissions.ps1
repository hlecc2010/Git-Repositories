﻿#Requires -Version 5.0

<#
.SYNOPSIS
    Retrieves the permissions of the share

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
    © ScriptRunner Software GmbH

.COMPONENT    

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/WinFileManagement/Shares

.Parameter ShareName
    [sr-en] Name of the share

.Parameter ComputerName
    [sr-en] Name of the computer from which to retrieve the share permissions
    
.Parameter AccessAccount
    [sr-en] User account that has permission to perform this action. If Credential is not specified, the current user account is used.
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$ShareName,
    [string]$ComputerName,
    [PSCredential]$AccessAccount
)

$Script:Cim = $null
[string[]]$Script:Properties = @("AccessControlType","AccessRight","AccountName")
try{
    if([System.String]::IsNullOrWhiteSpace($ComputerName)){
        $ComputerName=[System.Net.DNS]::GetHostByName('').HostName
    }          
    if($null -eq $AccessAccount){
        $Script:Cim =New-CimSession -ComputerName $ComputerName -ErrorAction Stop
    }
    else {
        $Script:Cim =New-CimSession -ComputerName $ComputerName -Credential $AccessAccount -ErrorAction Stop
    }

    $objShare = Get-SmbShareAccess -Name $ShareName -CimSession $Script:Cim -ErrorAction Stop `
                        | Select-Object $script:Properties | Sort-Object AccessControlType,AccountName | Format-List    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $objShare
    }
    else{
        Write-Output $objShare
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