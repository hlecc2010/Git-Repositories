﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Connect to Microsoft Exchange Server and removes the address list
    
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
        https://github.com/scriptrunner/ActionPacks/tree/master/Exchange/AddressLists

    .Parameter ListName
        [sr-en] Name, Display name, Distinguished name or Guid of the address list to remove
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ListName
)

try{
    Remove-AddressList -Identity $ListName -Recursive -Confirm:$false
    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Address list $($ListName) removed"
    } 
    else{
        Write-Output   "Address list $($ListName) removed"
    }
    
}
catch{
    throw
}
Finally{
    
}