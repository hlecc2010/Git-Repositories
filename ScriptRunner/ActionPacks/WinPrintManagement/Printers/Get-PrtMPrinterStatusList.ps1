﻿#Requires -Version 5.0

<#
.SYNOPSIS
    Get the status of all local printer from the specified computer

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
    https://github.com/scriptrunner/ActionPacks/tree/master/WinPrintManagement/Printers

.Parameter ComputerName
    [sr-en] Name of the computer from which to retrieve the printer informations
#>

[CmdLetBinding()]
Param(
    [string]$ComputerName
)

$null = [System.Reflection.Assembly]::LoadWithPartialName('System.Printing')

try{
    $Script:output = @()
    [System.Printing.PrintServer]$Script:Server
    if([System.string]::IsNullOrWhiteSpace($ComputerName)){
        $Script:Server = New-Object System.Printing.LocalPrintServer
    }
    else{
        if (-not $ComputerName.StartsWith("\\")){ 
            $ComputerName = "\\" + $ComputerName
        }
        $Script:Server = New-Object System.Printing.PrintServer($ComputerName)
    }
    if($null -ne $Script:Server){ 
        foreach($prn in $Script:Server.GetPrintQueues(@([System.Printing.EnumeratedPrintQueueTypes]::Local))){
            $Script:output += "Printer: $($prn.FullName)"
            $Script:output += "IsTonerLow: $($prn.IsTonerLow)"
            $Script:output += "IsPowerSaveOn: $($prn.IsPowerSaveOn)"
            $Script:output += "IsPrinting: $($prn.IsPrinting)"
            $Script:output += "IsProcessing: $($prn.IsProcessing)"
            $Script:output += "IsNotAvailable: $($prn.IsNotAvailable)"
            $Script:output += "IsOffline: $($prn.IsOffline)"
            $Script:output += "IsPaused: $($prn.IsPaused)"
            $Script:output += "IsBusy : $($prn.IsBusy)"
            $Script:output += "HasToner: $($prn.HasToner)"
            $Script:output += "------------------------------------"
        }
    }
    else{
        $Script:output += "Print server $($ComputerName) not found"
    }
    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:output
    }
    else{
        Write-Output $Script:output
    }
}
catch{
    throw
}
finally{
    if($null -ne $Script:Server){
        $Script:Server.Dispose()
    }
}