﻿#Requires -Version 5.0
# Requires -Modules VMware.VimAutomation.Core

<#
    .SYNOPSIS
        Configures a host account

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

    .Parameter Id
        [sr-en] ID of the host user account you want to configure
        [sr-en] Id des Benutzerkontos

    .Parameter Password
        [sr-en] New password of host user account you want to configure
        [sr-de] Neues Password des Benutzerkontos 

    .Parameter Description
        [sr-en] Description of the specified account
        [sr-de] Beschreibung des Benutzerkontos

    .Parameter GrantShellAccess
        [sr-en] Account is allowed to access the ESX shell
        [sr-en] Benutzer ist ESX shell berechtigt 
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$VIServer,
    [Parameter(Mandatory = $true)]
    [pscredential]$VICredential,
    [Parameter(Mandatory = $true)]
    [string]$Id,
    [Parameter(HelpMessage="asrdisplay(password)")]
    [string]$Password,
    [string]$Description,
    [bool]$GrantShellAccess
)

Import-Module VMware.VimAutomation.Core

try{   
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop
    
    $Script:uAccount = Get-VMHostAccount -Server $Script:vmServer -Id $Id -ErrorAction Stop
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'UserAccount' = $Script:uAccount
                            'Confirm' = $false
                            }                                

    if($PSBoundParameters.ContainsKey('Password') -eq $true){
        $Script:uAccount = Set-VMHostAccount @cmdArgs -Password $Password
    }
    if($PSBoundParameters.ContainsKey('Description') -eq $true){
        $Script:uAccount = Set-VMHostAccount @cmdArgs -Description $Description
    }
    if($PSBoundParameters.ContainsKey('GrantShellAccess') -eq $true){
        $Script:uAccount = Set-VMHostAccount @cmdArgs -GrantShellAccess $GrantShellAccess
    }
    $result = $Script:uAccount | Select-Object *

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