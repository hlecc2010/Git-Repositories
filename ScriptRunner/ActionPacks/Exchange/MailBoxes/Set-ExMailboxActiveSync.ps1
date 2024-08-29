﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Connect to Microsoft Exchange Server and sets the mailbox ActiveSync setting
    
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

    .Parameter Activate
        [sr-en] Enables or disables Exchange ActiveSync for the mailbox
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$MailboxId,
    [bool]$Activate
)

try{
    $box = Get-CASMailbox -Identity $MailboxId
    if($null -ne $box){
        Set-CASMailbox -Identity $MailboxId -ActiveSyncEnabled $Activate 
        $resultMessage =  Get-CASMailbox -Identity $MailboxId | Select-Object ActiveSyncEnabled,PrimarySmtpAddress,DisplayName
        if($SRXEnv) {
            $SRXEnv.ResultMessage = $resultMessage | Format-List
        } 
        else{
            Write-Output $resultMessage | Format-List
        }
    }
    else{
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Mailbox not found"
        } 
        Throw  "Mailbox not found"
    }
}
catch{
    throw
}
finally{
    
}