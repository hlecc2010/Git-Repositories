﻿#Requires -Version 5.0
#requires -Modules Microsoft.Graph.Groups 

<#
    .SYNOPSIS
        Add new entity to group Lifecycle Policy
    
    .DESCRIPTION          

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Modules Microsoft.Graph.Groups 

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/MS%20Graph/Groups

    .PARAMETER AlternateNotificationEmails
        [sr-en] List of email address to send notifications for groups without owners. 
        Multiple email address can be defined by separating email address with a semicolon
        [sr-de] Liste der E-Mail-Adressen, an die Benachrichtigungen für Gruppen ohne Besitzer gesendet werden sollen. 
        Mehrere E-Mail-Adressen können definiert werden, indem die E-Mail-Adressen durch ein Semikolon getrennt werden
        
    .Parameter GroupLifetimeInDays
        [sr-en] Group identifier
        [sr-de] Gruppen ID
        
    .Parameter ManagedGroupType
        [sr-en] Group type for which the expiration policy applies
        [sr-de] Gruppentyp, für den die Ablauf-Richtlinie gilt
#>

param( 
    [Parameter(Mandatory = $true)]
    [string]$AlternateNotificationEmails,
    [int]$GroupLifetimeInDays = 180,
    [ValidateSet('All','Selected','None')]
    [string]$ManagedGroupType = 'None'
)

Import-Module Microsoft.Graph.Groups 

try{
    [hashtable]$cmdArgs = @{ErrorAction = 'Stop'
                            'Confirm' = $false
                            'AlternateNotificationEmails' = $AlternateNotificationEmails
                            'ManagedGroupTypes' = $ManagedGroupType
                            'GroupLifetimeInDays' = $GroupLifetimeInDays
    } 
    $mgPol = New-MgGroupLifecyclePolicy @cmdArgs | Select-Object *

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $mgPol
    }
    else{
        Write-Output $mgPol
    }
}
catch{
    throw 
}
finally{
}