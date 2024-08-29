﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Connect to Microsoft Exchange Server and and sets the mailbox properties
        Only parameters with value are set 
    
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
        [sr-en] Alias, Display name, Distinguished name, SamAccountName, Guid or user principal name of the mailbox from which to set properties
    
    .Parameter Alias
        [sr-en] Alias name of the mailbox

    .Parameter DisplayName
        [sr-en] Display name of the mailbox

    .Parameter WindowsEmailAddress
        [sr-en] Windows mail address of the mailbox

    .Parameter FirstName
        [sr-en] User's first name

    .Parameter LastName
        [sr-en] User's last name

    .Parameter Office
        [sr-en] User's physical office name or number

    .Parameter Phone
        [sr-en] User's telephone number

    .Parameter ResetPasswordOnNextLogon
        [sr-en] User is required to change their password the next time they log on to their mailbox
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$MailboxId,    
    [string]$Alias,
    [string]$DisplayName ,    
    [string]$WindowsEmailAddress ,
    [string]$FirstName ,
    [string]$LastName ,
    [string]$Office ,
    [string]$Phone ,
    [switch]$ResetPasswordOnNextLogon
)

try{
    $box = Get-Mailbox -Identity $MailboxId 
    if($null -ne $box){
        [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                                'Identity' = $box.UserPrincipalName
                                'Confirm' = $false
                                }
        if($PSBoundParameters.ContainsKey('Alias') -eq $true ){
            Set-Mailbox @cmdArgs -Alias $Alias
        }
        if($PSBoundParameters.ContainsKey('DisplayName') -eq $true ){
            Set-Mailbox @cmdArgs -DisplayName $DisplayName
        }
        if($PSBoundParameters.ContainsKey('FirstName') -eq $true ){
            Set-User @cmdArgs -FirstName $FirstName
        }
        if($PSBoundParameters.ContainsKey('LastName') -eq $true ){
            Set-User @cmdArgs -LastName $LastName
        }
        if($PSBoundParameters.ContainsKey('Office') -eq $true ){
            Set-User @cmdArgs -Office $Office
        }
        if($PSBoundParameters.ContainsKey('Phone') -eq $true ){
            Set-User @cmdArgs -Phone $Phone
        }
        if($PSBoundParameters.ContainsKey('WindowsEmailAddress') -eq $true ){
            Set-Mailbox @cmdArgs -WindowsEmailAddress $WindowsEmailAddress
        }
        if($PSBoundParameters.ContainsKey('ResetPasswordOnNextLogon') -eq $true ){
            Set-User @cmdArgs -ResetPasswordOnNextLogon  $ResetPasswordOnNextLogon.ToBool()
        }
        $resultMessage = @()
        $resultMessage += Get-Mailbox -Identity $box.UserPrincipalName | `
                Select-Object AccountDisabled,Alias,DisplayName,Name,WindowsEmailAddress, `
                                ResetPasswordOnNextLogon         
        $resultMessage += Get-User -Identity $box.UserPrincipalName | `
                Select-Object FirstName,LastName,Office,Phone       
        if($SRXEnv) {
            $SRXEnv.ResultMessage = $resultMessage  
        }
        else{
            Write-Output $resultMessage
        }
    }
    else{
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Mailbox $($MailboxId) not found"
        } 
        Throw  "Mailbox $($MailboxId) not found"
    }
}
catch{
    throw
}
finally{
    
}