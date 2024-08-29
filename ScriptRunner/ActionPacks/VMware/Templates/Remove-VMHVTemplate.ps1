﻿#Requires -Version 5.0
# Requires -Modules VMware.VimAutomation.Core

<#
    .SYNOPSIS
        Removes the specified virtual machine templates from the inventory

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
        https://github.com/scriptrunner/ActionPacks/tree/master/VMware/Templates

    .Parameter VIServer
        [sr-en] IP address or the DNS name of the vSphere server to which you want to connect
        [sr-de] IP Adresse oder DNS des vSphere Servers

    .Parameter VICredential
        [sr-en] PSCredential object that contains credentials for authenticating with the server
        [sr-de] Benutzerkonto für die Ausführung

    .Parameter TemplateID
        [sr-en] ID of the virtual template
        [sr-de] ID der Vorlage

    .Parameter TemplateName
        [sr-en] Name of the virtual template
        [sr-de] Name der Vorlage

    .Parameter DeletePermanently
        [sr-en] Delete the templates not only from the inventory, but from the datastore as well
        [sr-de] Vorlage wird nicht nur aus dem Inventar, sondern auch aus dem Datenspeicher gelöscht
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
    [string]$TemplateID,
    [Parameter(Mandatory = $true,ParameterSetName = "byName")]
    [string]$TemplateName,
    [Parameter(ParameterSetName = "byID")]
    [Parameter(ParameterSetName = "byName")]
    [switch]$DeletePermanently
)

Import-Module VMware.VimAutomation.Core

try{
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop
    
    if($PSCmdlet.ParameterSetName  -eq "byID"){
        $Script:temp = Get-Template -Server $Script:vmServer -Id $TemplateID -ErrorAction Stop
    }
    else{
        $Script:temp = Get-Template -Server $Script:vmServer -Name $TemplateName -ErrorAction Stop
    }
    $null = Remove-Template -Template $Script:temp -DeletePermanently:$DeletePermanently -Server $Script:vmServer -Confirm:$false -ErrorAction Stop
    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Template $($Script:temp.Name) successfully removed"
    }
    else{
        Write-Output "Template $($Script:temp.Name) successfully removed"
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