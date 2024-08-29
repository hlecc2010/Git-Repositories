﻿#Requires -Version 5.0
#Requires -Modules AzureAD

<#
    .SYNOPSIS
        Connect to Azure Active Directory and gets all groups
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT       
        Azure Active Directory Powershell Module 

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/AzureAD/Groups

    .Parameter SearchString
        [sr-en] Search string
#>

param(
    [string]$SearchString
)

try{
    $Grps = Get-AzureADGroup -All $true -SearchString $SearchString
    if($null -ne $Grps){
        if($SRXEnv) {
            $SRXEnv.ResultMessage = $Grps | Sort-Object -Property DisplayName | Format-List -Property DisplayName,Description,Mail, Objectid, ObjectType
        } 
        else{
            Write-Output $Grps | Sort-Object -Property DisplayName | Format-List -Property DisplayName,Description,Mail, Objectid, ObjectType
        }
    }
    else {
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "No groups found"
        } 
        else{
            Write-Output "No groups found"
        }
    }
}
finally{
  
}