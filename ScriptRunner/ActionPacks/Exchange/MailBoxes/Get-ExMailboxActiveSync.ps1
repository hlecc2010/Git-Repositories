﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Connect to Microsoft Exchange Server and gets the mailbox ActiveSync setting
    
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
        https://github.com/scriptrunner/ActionPacks/tree/master/Exchange/MailBoxes

    .Parameter MailboxId
        [sr-en] Alias, Display name, Distinguished name, SamAccountName, Guid or user principal name of the mailbox from which to set ActiveSync
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$MailboxId
)

try{
    $resultMessage =  Get-CASMailbox -Identity $MailboxId -ErrorAction Stop | Select-Object ActiveSyncEnabled,PrimarySmtpAddress,DisplayName
    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $resultMessage | Format-List
    } 
    else{
        Write-Output $resultMessage | Format-List
    }
}
catch{
    throw
}
finally{
    
}