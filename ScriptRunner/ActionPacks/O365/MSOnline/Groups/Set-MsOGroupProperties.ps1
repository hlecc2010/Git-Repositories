﻿#Requires -Version 5.0
#Requires -Modules MSOnline

<#
    .SYNOPSIS
        Connect to MS Online and updates the properties of a Azure Active Directory group.
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
        Azure Active Directory Powershell Module

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/MSOnline/Groups

    .Parameter GroupObjectId
        [sr-en] Unique ID of the group to update

    .Parameter GroupName
        [sr-en] Display name of the group to remove

    .Parameter Description
        [sr-en] Description of the group

    .Parameter DisplayName
        [sr-en] New display name of the group

    .Parameter TenantId
        [sr-en] Unique ID of the tenant on which to perform the operation
#>

param(
    [Parameter(Mandatory = $true,ParameterSetName = "Group object id")]
    [guid]$GroupObjectId,
    [Parameter(Mandatory = $true,ParameterSetName = "Group name")]
    [string]$GroupName,
    [Parameter(ParameterSetName = "Group name")]
    [Parameter(ParameterSetName = "Group object id")]
    [string]$Description,
    [Parameter(ParameterSetName = "Group name")]
    [Parameter(ParameterSetName = "Group object id")]
    [string]$DisplayName,
    [Parameter(ParameterSetName = "Group name")]
    [Parameter(ParameterSetName = "Group object id")]
    [guid]$TenantId
)
 
try{
    $Script:Grp
    if($PSCmdlet.ParameterSetName  -eq "Group object id"){
        $Script:Grp = Get-MsolGroup -ObjectId $GroupObjectId -TenantId $TenantId 
    }
    else{
        $Script:Grp = Get-MsolGroup -TenantId $TenantId | Where-Object {$_.Displayname -eq $GroupName} 
    }
    if($null -ne $Script:Grp){
        if(-not [System.String]::IsNullOrWhiteSpace($Description)){
            $null = Set-MsolGroup -ObjectId $Script:Grp.ObjectId -TenantId $TenantId -Description $Description
        }
        if(-not [System.String]::IsNullOrWhiteSpace($DisplayName)){
            $null = Set-MsolGroup -ObjectId $Script:Grp.ObjectId -TenantId $TenantId -DisplayName $DisplayName
        }
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Group $($Script:Grp.DisplayName) changed"
        } 
        else{
            Write-Output  "Group $($Script:Grp.DisplayName) changed"
        }
    }
    else{
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Group not found"
        }    
        Throw "Group not found"
    }
}
catch{
    throw
}