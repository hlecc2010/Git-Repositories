﻿#Requires -Version 5.0
#requires -Modules Microsoft.Graph.Users

<#
    .SYNOPSIS
        Collection of open extensions defined for the task

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

    .Parameter TodoListId
        [sr-en] Unique identifier of todoTaskList
        [sr-de] ID der ToDo Liste

    .Parameter TodoTaskId
        [sr-en] Unique identifier of todoTask
        [sr-de] ID des ToDo Tasks

    .Parameter ExtensionId
        [sr-en] Extension Id
        [sr-de] Extension ID
#>

param( 
    [Parameter(Mandatory = $true)]
    [string]$UserId,
    [Parameter(Mandatory = $true)]
    [string]$TodoListId,
    [Parameter(Mandatory = $true)]
    [string]$TodoTaskId,
    [Parameter(Mandatory = $true)]
    [string]$ExtensionId
)

Import-Module Microsoft.Graph.Users

try{
    [hashtable]$cmdArgs = @{ErrorAction = 'Stop'    
                        'UserId'= $UserId
                        'TodoTaskListId' = $TodoListId
                        'TodoTaskId' = $TodoListId
                        'ExtensionId' = $ExtensionId
    }
    $result = Get-MgUserTodoTaskExtension @cmdArgs | Select-Object *

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