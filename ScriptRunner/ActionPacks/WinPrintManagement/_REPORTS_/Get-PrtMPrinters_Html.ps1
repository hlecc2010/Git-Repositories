﻿#Requires -Version 5.0
#Requires -Modules PrintManagement

<#
.SYNOPSIS
    Generates a report with one or all local printers from the specified computer

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
    Requires Library Script ReportLibrary from the Action Pack Reporting\_LIB_

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/WinPrintManagement/_REPORTS_ 

.Parameter PrinterName
    [sr-en] Name of the printer from which to retrieve the status

.Parameter ComputerName
    [sr-en] Name of the computer from which to retrieve the printer information
    
.Parameter AccessAccount
    [sr-en] User account that has permission to perform this action. If Credential is not specified, the current user account is used.

.Parameter IncludeTcpIpPortProperties
    [sr-en] Get the TCP/IP port address and number
#>

[CmdLetBinding()]
Param(
    [string]$PrinterName,
    [string]$ComputerName,
    [PSCredential]$AccessAccount,
    [switch]$IncludeTcpIpPortProperties
)

Import-Module PrintManagement

$Script:Cim = $null
try{
    [string[]]$Properties = @('Name','Shared','Sharename','DriverName','PortName')
    if([System.string]::IsNullOrWhiteSpace($ComputerName)){
        $ComputerName = [System.Net.DNS]::GetHostByName('').HostName
    }          
    if($null -eq $AccessAccount){
        $Script:Cim = New-CimSession -ComputerName $ComputerName -ErrorAction Stop
    }
    else {
        $Script:Cim = New-CimSession -ComputerName $ComputerName -Credential $AccessAccount -ErrorAction Stop
    }
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'Full' = $null
                            'CimSession' = $Script:Cim
                            'ComputerName' = $ComputerName
                            }
    if([System.string]::IsNullOrWhiteSpace($PrinterName) -eq $false){
        $cmdArgs.Add('Name',$PrinterName)
    }
    $printers = Get-Printer @cmdArgs | Where-Object {$_.Type -eq 'Local'} `
                                    | Select-Object $Properties | Sort-Object Name
    $Script:Csv=@()
    $Script:Msg=@()
    $Script:Port
    foreach($item in $printers)
    {
        $tmp= ([ordered] @{            
            ComputerName= $ComputerName
            PrinterName = $item.Name
            Shared = $item.Shared
            DifferentShareName = ''
            PortAddress= $item.PortName
            PortNumber = ''
            PrinterDriver= $item.DriverName
        }   )
        if($item.Shared -and $item.Sharename -ne $item.Name){
            $tmp.DifferentShareName = $item.Sharename
        }
        if($IncludeTcpIpPortProperties){
            try{
                $Script:Port = Get-PrinterPort -CimSession $Script:Cim -Name $item.PortName -ComputerName $ComputerName -ErrorAction SilentlyContinue
                if($null -ne $Script:Port.PrinterHostAddress){
                    $tmp.PortAddress =$Script:Port.PrinterHostAddress                
                    if($null -ne $Script:Port.PortNumber){
                        $tmp.PortNumber =$Script:Port.PortNumber
                    }                
                }
            }
            catch{
                Write-Output "Error get printer port $($item.PortName) / $($_.Exception.Message)"
            }
        }
        $Script:Csv += New-Object PSObject -Property $tmp 
    }

    ConvertTo-ResultHtml -Result $Script:Csv
}
catch{
    throw
}
finally{
    if($null -ne $Script:Cim){
        Remove-CimSession $Script:Cim 
    }
}