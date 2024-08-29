﻿#Requires -Version 5.0
#requires -Modules Microsoft.Graph.Users

<#
    .SYNOPSIS
        Removes category defined for the user
    
    .DESCRIPTION          

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Modules Microsoft.Graph.Users

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/MS%20Graph/Users

    .Parameter UserId
        [sr-en] User identifier
        [sr-de] Benutzer ID

    .Parameter CategoryId
        [sr-en] Id of Outlook category
        [sr-de] Id der Category
#>

param( 
    [Parameter(Mandatory = $true)]
    [string]$UserId,     
    [Parameter(Mandatory = $true)]
    [string]$CategoryId
)

Import-Module Microsoft.Graph.Users

try{
    [hashtable]$cmdArgs = @{ErrorAction = 'Stop'    
                        'UserId'= $UserId
                        'OutlookCategoryId' = $CategoryId
                        'Confirm' = $false
                        'PassThru' = $null
    }
    $result = Remove-MgUserOutlookMasterCategory @cmdArgs
    
    if($null -ne $SRXEnv) {
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