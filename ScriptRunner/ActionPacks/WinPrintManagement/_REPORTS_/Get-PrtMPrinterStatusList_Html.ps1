﻿#Requires -Version 5.0

<#
.SYNOPSIS
    Generates a report with the status of one or all local printer from the specified computer

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
    https://github.com/scriptrunner/ActionPacks/tree/master/WinPrintManagement/_REPORTS_ 

.Parameter ComputerName
    [sr-en] Name of the computer from which to retrieve the printer informations

.Parameter PrinterName
    [sr-en] Name of the printer from which to retrieve the informations
#>

[CmdLetBinding()]
Param(
    [string]$ComputerName,
    [string]$PrinterName
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
        $printers = $Script:Server.GetPrintQueues(@([System.Printing.EnumeratedPrintQueueTypes]::Local))
        if([System.string]::IsNullOrWhiteSpace($PrinterName) -eq $false){
            $printers = $printers | Where-Object {$_.Name -eq $PrinterName}
        }
        foreach($prn in $printers | Sort-Object Name){
            $Script:output += [PSCustomObject] @{
                "Printer" = $($prn.Name);
                "IsTonerLow" = $($prn.IsTonerLow);
                "IsPowerSaveOn" = $($prn.IsPowerSaveOn);
                "IsPrinting" = $($prn.IsPrinting);
                "IsProcessing" = $($prn.IsProcessing);
                "IsNotAvailable" = $($prn.IsNotAvailable);
                "IsOffline" = $($prn.IsOffline);
                "IsPaused" = $($prn.IsPaused);
                "IsBusy" = $($prn.IsBusy);
                "HasToner" = $($prn.HasToner)
            }
        }
    }
    else{
        $Script:output += "Print server $($ComputerName) not found"
    }
    
    ConvertTo-ResultHtml -Result $Script:output
}
catch{
    throw
}
finally{
    if($null -ne $Script:Server){
        $Script:Server.Dispose()
    }
}