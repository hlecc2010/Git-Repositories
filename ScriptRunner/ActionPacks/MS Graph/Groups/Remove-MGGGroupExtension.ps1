﻿#Requires -Version 5.0
#requires -Modules Microsoft.Graph.Groups 

<#
    .SYNOPSIS
        Removes a collection of open extensions defined for the group
    
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
        
    .Parameter ExtensionID
        [sr-en] Id of extension
        [sr-de] ID der Erweiterung
#>

param( 
    [Parameter(Mandatory = $true)]
    [string]$GroupId,
    [Parameter(Mandatory = $true)]
    [string]$ExtensionID
)

Import-Module Microsoft.Graph.Groups

try{
    [hashtable]$cmdArgs = @{ErrorAction = 'Stop'    
                        'GroupId'= $GroupId    
                        'ExtensionId' = $ExtensionID
                        'Confirm' = $false
                        'PassThru' = $false
    }
    $result = Remove-MgGroupExtension @cmdArgs | Select-Object *

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