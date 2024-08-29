﻿#Requires -Version 5.0
#Requires -Modules Az.KeyVault

<#
    .SYNOPSIS
        Grants or modifies existing permissions for a user
    
    .DESCRIPTION  
        
    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module Az.KeyVault

    .LINK
        https://github.com/scriptrunner/ActionPacks/blob/master/Azure/KeyVault

    .Parameter VaultName
        [sr-en] Name of the key vault   
        [sr-de] Namen des Key Vaults

    .Parameter EmailAddress
        [sr-en] Email address of the user to whom to grant permissions
        [sr-de] E-Mail-Adresse des Benutzers, dem Berechtigungen erteilt werden sollen

    .Parameter UserPrincipalName
        [sr-en] UserPrincipalName of the user to whom to grant permissions
        [sr-de] UserPrincipalName des Benutzers, dem Berechtigungen erteilt werden sollen

    .Parameter PermissionsToCertificates
        [sr-en] Certificate permissions to grant to a user 
        [sr-de] Zertifikatsberechtigungen des Benutzers

    .Parameter PermissionsToKeys
        [sr-en] Key operation permissions to grant to a user 
        [sr-de] Rechte für Schlüssel-Operationen des Benutzers

    .Parameter PermissionsToSecrets
        [sr-en] Secret operation permissions to grant to a user
        [sr-de] Rechte für Secret-Operationen des Benutzers

    .Parameter PermissionsToStorage
        [sr-en] Storage account and SaS-definition operation permissions to grant to a user
        [sr-de] Speicherkonto und SaS-Definition Operationsberechtigungen des Benutzers
#>

param( 
    [Parameter(Mandatory = $true,ParameterSetName = 'ByEmailAddress')]
    [Parameter(Mandatory = $true,ParameterSetName = 'ByUPN')]
    [string]$VaultName,
    [Parameter(Mandatory = $true,ParameterSetName = 'ByEmailAddress')]
    [string]$EmailAddress,
    [Parameter(Mandatory = $true,ParameterSetName = 'ByUPN')]
    [string]$UserPrincipalName,
    [Parameter(ParameterSetName = 'ByEmailAddress')]
    [Parameter(ParameterSetName = 'ByUPN')]
    [ValidateSet('All','Get','List','Delete','Create','Import','Update','Managecontacts','Getissuers','Listissuers',
                'Setissuers','Deleteissuers','Manageissuers','Recover','Backup','Restore','Purge')]
    [string[]]$PermissionsToCertificates,
    [Parameter(ParameterSetName = 'ByEmailAddress')]
    [Parameter(ParameterSetName = 'ByUPN')]
    [ValidateSet('All','Decrypt','Encrypt','UnwrapKey','WrapKey','Verify','Sign','Get','List',
                'Update','Create','Import','Delete','Backup','Restore','Recover','Purge','Rotate')]
    [string[]]$PermissionsToKeys,
    [Parameter(ParameterSetName = 'ByEmailAddress')]
    [Parameter(ParameterSetName = 'ByUPN')]
    [ValidateSet('All','Get','List','Set','Delete','Backup','Restore','Recover','Purge')]
    [string[]]$PermissionsToSecrets,
    [Parameter(ParameterSetName = 'ByEmailAddress')]
    [Parameter(ParameterSetName = 'ByUPN')]
    [ValidateSet('all','get','list','delete','set','update','regeneratekey','getsas','listsas',
                'deletesas','setsas','recover','backup','restore','purge')]
    [string[]]$PermissionsToStorage
)

Import-Module Az.KeyVault

try{
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                'VaultName' = $VaultName
                'Confirm' = $false
                'PassThru' = $null
    }
    if($PSCmdlet.ParameterSetName -eq 'ByUPN'){
        $cmdArgs.Add('UserPrincipalName',$UserPrincipalName)
    }
    else{
        $cmdArgs.Add('EmailAddress',$EmailAddress)
    }
    if($PSBoundParameters.ContainsKey('PermissionsToCertificates') -eq $true){
        $cmdArgs.Add('PermissionsToCertificates',$PermissionsToCertificates)
    }
    if($PSBoundParameters.ContainsKey('PermissionsToKeys') -eq $true){
        $cmdArgs.Add('PermissionsToKeys',$PermissionsToKeys)
    }
    if($PSBoundParameters.ContainsKey('PermissionsToSecrets') -eq $true){
        $cmdArgs.Add('PermissionsToSecrets',$PermissionsToSecrets)
    }
    if($PSBoundParameters.ContainsKey('PermissionsToStorage') -eq $true){
        $cmdArgs.Add('PermissionsToStorage',$PermissionsToStorage)
    }
    $ret = Set-AzKeyVaultAccessPolicy @cmdArgs

    if($null -ne $SRXEnv) {
        $SRXEnv.ResultMessage = $ret 
    }
    else{
        Write-Output $ret
    }
}
catch{
    throw
}
finally{
}