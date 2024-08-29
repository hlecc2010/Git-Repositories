﻿#Requires -Version 5.0

<#
.SYNOPSIS
    Get the error values of the printer from the specified computer

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

.Parameter PrinterName
    [sr-en] Name of the printer from which to retrieve the status

.Parameter ComputerName
    [sr-en] Name of the computer from which to retrieve the printer information
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$PrinterName,
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
        Try{
            $Script:que = $Script:Server.GetPrintQueue($PrinterName)
        }
        catch{

        }
        if($null -eq $Script:que){
            foreach($prn in $Script:Server.GetPrintQueues(@([System.Printing.EnumeratedPrintQueueTypes]::Local))){
                if($prn.FullName -eq $PrinterName -or $prn.Name -eq $PrinterName){
                    $Script:que = $prn
                    break
                }
            }            
        }
        if($null -ne $Script:que){
            $Script:output += "PagePunt: $($Script:que.PagePunt)"
            $Script:output += "NeedUser: $($Script:que.NeedUserIntervention)"
            $Script:output += "HasPaperProblem: $($Script:que.HasPaperProblem)"
            $Script:output += "IsInError: $($Script:que.IsInError)"
            $Script:output += "IsOutOfMemory: $($Script:que.IsOutOfMemory)"
            $Script:output += "IsOutOfPaper: $($Script:que.IsOutOfPaper)"
            $Script:output += "IsOutputBinFull: $($Script:que.IsOutputBinFull)"
            $Script:output += "IsPaperJammed : $($Script:que.IsPaperJammed)"
            $Script:output += "IsServerUnknown: $($Script:que.IsServerUnknown)"
            $Script:que.Dispose()
        }
        else{
            $Script:output += "Printer $($PrinterName) not found on computer $($ComputerName)"
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