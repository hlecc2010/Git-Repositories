﻿#Requires -Version 5.0
#Requires -Modules @{ModuleName = "microsoftteams"; ModuleVersion = "1.1.5"}

<#
.SYNOPSIS
    Removes a Teams App installed in Microsoft Teams

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
    https://github.com/scriptrunner/ActionPacks/tree/master/O365/MS-Teams/Apps

.Parameter AppId
    [sr-en] Teams App identifier in Microsoft Teams
    [sr-de] Teams App ID in Microsoft Teams

.Parameter TeamID
    [sr-en] Team identifier in Microsoft Teams
    [sr-de] ID des Microsoft Teams
    
.Parameter UserID
    [sr-en] User identifier in Microsoft Teams
    [sr-de] Benutzer ID in Microsoft Teams

.Parameter AppInstallationId     
    [sr-en] Installation identifier of the Teams App
    [sr-de] Installations ID der Teams App
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true,ParameterSetName ="byTeam")]   
    [string]$TeamID,
    [Parameter(Mandatory = $true,ParameterSetName ="byUser")]  
    [string]$UserID,    
    [Parameter(ParameterSetName ="byTeam")]   
    [Parameter(ParameterSetName ="byUser")]  
    [string]$AppId,   
    [Parameter(ParameterSetName ="byTeam")]   
    [Parameter(ParameterSetName ="byUser")]  
    [string]$AppInstallationId
)

Import-Module microsoftteams

try{
    [string[]]$Properties = @('DisplayName','TeamsAppId','Version','TeamsAppDefinitionId')

    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'}

    if($PSCmdlet.ParameterSetName -eq 'byTeam'){
        $cmdArgs.Add('TeamID',$TeamID)
    }
    else{
        $cmdArgs.Add('UserID',$UserID)
    }    
    if($PSBoundParameters.ContainsKey('AppId')){
        $cmdArgs.Add('AppId',$AppId)
    } 
    if($PSBoundParameters.ContainsKey('AppInstallationId')){
        $cmdArgs.Add('AppInstallationId',$AppInstallationId)
    }     

    $null = Remove-TeamsAppInstallation @cmdArgs
    $cmdArgs.Remove('AppId')
    $cmdArgs.Remove('AppInstallationId')
    $result = Get-TeamsAppInstallation @cmdArgs | Sort-Object DisplayName | Select-Object $Properties
    
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
}