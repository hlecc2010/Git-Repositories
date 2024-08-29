﻿#Requires -Version 5.0
#Requires -Modules AzureAD

<#
    .SYNOPSIS
        Gets a list of users
    
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
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/AzureAD/_QUERY_
#>

param(    
)
 
try{
    $result = Get-AzureADUser -All $true  | `
        Select-Object DisplayName, UserPrincipalName -Unique | `
        Sort-Object -Property DisplayName
    
    foreach($itm in  $result){
        if($SRXEnv) {            
            $null = $SRXEnv.ResultList.Add($itm.UserPrincipalName) # Value
            $null = $SRXEnv.ResultList2.Add($itm.DisplayName) # DisplayValue            
        }
        else{
            Write-Output $itm.DisplayName 
        }
    }
}
finally{
 
}