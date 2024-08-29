﻿#Requires -Version 5.0
# Requires -Modules VMware.VimAutomation.Core

<#
    .SYNOPSIS
        Moves the specified host to another location

    .DESCRIPTION

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module VMware.VimAutomation.Core

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/VMware/Host

    .Parameter VIServer
        [sr-en] IP address or the DNS name of the vSphere server to which you want to connect
        [sr-de] IP Adresse oder DNS des vSphere Servers

    .Parameter VICredential
        [sr-en] PSCredential object that contains credentials for authenticating with the server
        [sr-de] Benutzerkonto für die Ausführung

    .Parameter ID
        [sr-en] ID of the host you want to move to another location
        [sr-de] Id des Host

    .Parameter Name
        [sr-en] Name of the host you want to move to another location
        [sr-de] Hostname

    .Parameter DestinationName
        [sr-en] Destination where you want to move the host
        [sr-de] Ziel
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true,ParameterSetName = "byID")]
    [Parameter(Mandatory = $true,ParameterSetName = "byName")]
    [string]$VIServer,
    [Parameter(Mandatory = $true,ParameterSetName = "byID")]
    [Parameter(Mandatory = $true,ParameterSetName = "byName")]
    [pscredential]$VICredential,
    [Parameter(Mandatory = $true,ParameterSetName = "byID")]
    [string]$ID,
    [Parameter(Mandatory = $true,ParameterSetName = "byName")]
    [string]$Name,
    [Parameter(Mandatory = $true,ParameterSetName = "byID")]
    [Parameter(Mandatory = $true,ParameterSetName = "byName")]
    [switch]$DestinationName
)

Import-Module VMware.VimAutomation.Core

try{
    [string[]]$Properties = @('Name','Id','PowerState','ConnectionState','IsStandalone','LicenseKey')
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop

    if($PSCmdlet.ParameterSetName  -eq "byID"){
        $Script:vmHost = Get-VMHost -Server $Script:vmServer -ID $ID -ErrorAction Stop
    }
    else{
        $Script:vmHost = Get-VMHost -Server $Script:vmServer -Name $Name -ErrorAction Stop
    }
    $Script:destination = Get-Folder -Server $Script:vmServer -Name $DestinationName -ErrorAction Stop
    if($null -eq $Script:destination){
        throw "Destination $($DestinationName) not found"
    }
    $null = Move-VMHost -VMHost $Script:vmHost -Destination -$Script:destination -Server $Script:vmServer -Confirm:$false -ErrorAction Stop
    $result = Get-VMHost -Server $Script:vmServer -Name $Script:vmHost.Name  -NoRecursion:$NoRecursion -ErrorAction Stop | Select-Object $Properties

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $result
    }
    else{
        Write-Output $result
    }
}
catch{
    throw
}
finally{    
    if($null -ne $Script:vmServer){
        Disconnect-VIServer -Server $Script:vmServer -Force -Confirm:$false
    }
}