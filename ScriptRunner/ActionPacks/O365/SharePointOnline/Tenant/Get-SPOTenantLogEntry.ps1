﻿#Requires -Version 5.0
#Requires -Modules Microsoft.Online.SharePoint.PowerShell

<#
    .SYNOPSIS
        Retrieves SharePoint Online company logs
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module Microsoft.Online.SharePoint.PowerShell

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/SharePointOnline/Tenant

    .Parameter User
        [sr-en] Log-on identity as a filter

    .Parameter CorrelationId
        [sr-en] Correlation ID as a filter

    .Parameter Source
        [sr-en] Component that logs the errors

    .Parameter EndTime
        [sr-en] End time to search for logs

    .Parameter StartTime
        [sr-en] Start time to search for logs

    .Parameter MaxRows
        [sr-en] Maximum number of rows in the descending order of timestamp
#>

param(   
    [Parameter(Mandatory = $true,ParameterSetName = 'CorrelationId')]
    [string]$CorrelationId,
    [Parameter(Mandatory = $true,ParameterSetName = 'Source')]
    [int]$Source,
    [Parameter(Mandatory = $true,ParameterSetName = 'User')]
    [string]$User,
    [Parameter(ParameterSetName = 'SiteSubscription',HelpMessage="ASRDisplay(Date)")]
    [Parameter(ParameterSetName = 'CorrelationId',HelpMessage="ASRDisplay(Date)")]
    [Parameter(ParameterSetName = 'Source',HelpMessage="ASRDisplay(Date)")]
    [Parameter(ParameterSetName = 'User',HelpMessage="ASRDisplay(Date)")]
    [datetime]$StartTime,
    [Parameter(ParameterSetName = 'SiteSubscription',HelpMessage="ASRDisplay(Date)")]
    [Parameter(ParameterSetName = 'CorrelationId',HelpMessage="ASRDisplay(Date)")]
    [Parameter(ParameterSetName = 'Source',HelpMessage="ASRDisplay(Date)")]
    [Parameter(ParameterSetName = 'User',HelpMessage="ASRDisplay(Date)")]
    [datetime]$EndTime,
    [Parameter(ParameterSetName = 'SiteSubscription')]
    [Parameter(ParameterSetName = 'CorrelationId')]
    [Parameter(ParameterSetName = 'Source')]
    [Parameter(ParameterSetName = 'User')]
    [ValidateRange(1,5000)]
    [uint32]$MaxRows = 1000
)

Import-Module Microsoft.Online.SharePoint.PowerShell

try{
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'MaxRows' = $MaxRows
                            }     

    if(($null -ne $StartTime) -and ($StartTime.Year -gt 2010)){
        $cmdArgs.Add('StartTimeInUtc', $StartTime)
    }  
    if(($null -ne $EndTime) -and ($EndTime.Year -gt 2010)){
        $cmdArgs.Add('EndTimeInUtc', $EndTime)
    }     
    if($PSCmdlet.ParameterSetName -eq 'CorrelationId'){
        $cmdArgs.Add('CorrelationId', $CorrelationId)
    }      
    if($PSCmdlet.ParameterSetName -eq 'Source'){
        $cmdArgs.Add('Source', $Source)
    }     
    if($PSCmdlet.ParameterSetName -eq 'User'){
        $cmdArgs.Add('User', $User)
    } 

    $result = Get-SPOTenantLogEntry @cmdArgs | Select-Object *
      
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $result
    }
    else {
        Write-Output $result 
    }    
}
catch{
    throw
}
finally{
}