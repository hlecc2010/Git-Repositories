﻿#Requires -Version 5.0
#Requires -Modules Hyper-V

<#
    .SYNOPSIS
        Invokes a command for the virtual machine from the Hyper-V host.
        The acceptable commands are: Start, Stop, Suspend, Resume, Restart, Save and Turn off
    
    .DESCRIPTION  
        Use "Win2K12R2 or Win8.x" for execution on Windows Server 2012 R2 or on Windows 8.1,
        when execute on Windows Server 2016 / Windows 10 or newer, use "Newer Systems"

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module Hyper-V

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/Hyper-V/VMs

    .Parameter VMHostName
        [sr-en] Name of the Hyper-V host

    .Parameter HostName
        [sr-en] Name of the Hyper-V host

    .Parameter AccessAccount
        [sr-en] User account that have permission to perform this action

    .Parameter VMName
        [sr-en] Name or identifier of the virtual machine to be retrieved

    .Parameter Command
        [sr-en] Command that executed on the virtual machine 
#>

param(
    [Parameter(Mandatory = $true,ParameterSetName = "Win2K12R2 or Win8.x")]
    [string]$VMHostName,
    [Parameter(Mandatory = $true,ParameterSetName = "Win2K12R2 or Win8.x")]
    [Parameter(Mandatory = $true,ParameterSetName = "Newer Systems")]
    [string]$VMName,
    [Parameter(Mandatory = $true,ParameterSetName = "Win2K12R2 or Win8.x")]
    [Parameter(Mandatory = $true,ParameterSetName = "Newer Systems")]
    [ValidateSet('Start','Stop','Suspend','Resume','Restart','TurnOff','Save')]
    [string]$Command,
    [Parameter(ParameterSetName = "Newer Systems")]
    [string]$HostName,
    [Parameter(ParameterSetName = "Newer Systems")]
    [PSCredential]$AccessAccount
)

Import-Module Hyper-V

try {
    $Script:output
    if($PSCmdlet.ParameterSetName  -eq "Win2K12R2 or Win8.x"){
        $HostName=$VMHostName
    }    
    if([System.String]::IsNullOrWhiteSpace($HostName)){
        $HostName = "."
    }
    if($null -eq $AccessAccount){
        $Script:VM = Get-VM -ComputerName $HostName -ErrorAction Stop | Where-Object {$_.VMName -eq $VMName -or $_.VMID -eq $VMName}
    }
    else {
        $Script:Cim = New-CimSession -ComputerName $HostName -Credential $AccessAccount
        $Script:VM = Get-VM -CimSession $Script:Cim -ErrorAction Stop | Where-Object {$_.VMName -eq $VMName -or $_.VMID -eq $VMName}
    }        
    if($null -ne $Script:VM){
        if($Command -eq 'Start'){
            Start-VM -VM $Script:VM 
        }
        elseif($Command -eq 'Stop'){
            Stop-VM -VM $Script:VM -Force
        }
        elseif($Command -eq 'Save'){
            Stop-VM -VM $Script:VM -Save
        } 
        elseif($Command -eq 'TurnOff'){
            Stop-VM -VM $Script:VM -TurnOff
        }
        elseif($Command -eq 'Suspend'){
            Suspend-VM -VM $Script:VM 
        }
        elseif($Command -eq 'Resume'){
            Resume-VM -VM $Script:VM 
        }
        elseif($Command -eq 'Restart'){
            Restart-VM -VM $Script:VM -Force
        }
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Command $($Command) executed on VM $($VMName)"
        }    
        else {
            Write-Output "Command $($Command) executed on VM $($VMName)"
        }
    }
    else{
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Virtual machine $($VMName) not found"
        }    
        Throw "Virtual machine $($VMName) not found"
    }
}
catch {
    throw
}
finally{
    if($null -ne $Script:Cim){
        Remove-CimSession $Script:Cim 
    }
}