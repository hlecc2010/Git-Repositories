﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Generates a report with the resources
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH 

    .COMPONENT     
        Requires Library Script ReportLibrary from the Action Pack Reporting\_LIB_

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/ExchangeOnline/_Reports_
#>

param(
)

try{
    [string[]]$Properties = @('Name','IsMailboxEnabled','ProhibitSendQuota','RecipientLimits','IsShared','Database','ExchangeUserAccountControl','ExternalOofOptions')
    $res = Get-Mailbox -SortBy DisplayName -ErrorAction Stop | Where-Object -Property IsResource -eq $true  | Select-Object $Properties
    
    ConvertTo-ResultHtml -Result $res
}
catch{
    throw
}
finally{
    
}