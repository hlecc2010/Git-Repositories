﻿#Requires -Version 5.0
#requires -Modules Microsoft.Graph.Groups 

<#
    .SYNOPSIS
        Invoke action validateProperties
    
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
        
    .Parameter GroupId
        [sr-en] Group identifier
        [sr-de] Gruppen ID
        
    .Parameter DisplayName
        [sr-en] , must set when MailNickname is empty
        [sr-de] , muss belegt sein wenn MailNickname leer ist
        
    .Parameter MailNickname
        [sr-en] , must set when DisplayName is empty
        [sr-de] , muss belegt sein wenn DisplayName leer ist
#>

param(
    [Parameter(Mandatory = $true)] 
    [string]$GroupId,
    [Parameter(Mandatory = $true)] 
    [string]$DisplayName,
    [Parameter(Mandatory = $true)] 
    [string]$MailNickname
)

Import-Module Microsoft.Graph.Groups 

try{
    [hashtable]$cmdArgs = @{ErrorAction = 'Stop'
                            'GroupId' = $GroupId
                            'Confirm' = $false
                            'PassThru' = $null
    }    
    if($PSBoundParameters.ContainsKey('DisplayName') -eq $true){
        $cmdArgs.Add('DisplayName',$DisplayName)
    }    
    if($PSBoundParameters.ContainsKey('MailNickname') -eq $true){
        $cmdArgs.Add('MailNickname',$MailNickname)
    }
    $mgGroup = Test-MgGroupProperty @cmdArgs

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $mgGroup
    }
    else{
        Write-Output $mgGroup
    }
}
catch{
    throw 
}
finally{
}