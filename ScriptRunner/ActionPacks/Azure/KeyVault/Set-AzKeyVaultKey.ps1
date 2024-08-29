﻿#Requires -Version 5.0
#Requires -Modules Az.KeyVault

<#
    .SYNOPSIS
        Updates the attributes of a key in a key vault
    
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

    .Parameter KeyName
        [sr-en] Name of the key bundle to get
        [sr-de] Namen des Key Bundles

    .Parameter NotBefore
        [sr-en] Time before which key can't be used  
        [sr-de] Zeitpunkt ab wann der Schlüssel verwendet werden kann

    .Parameter Expires
        [sr-en] Expiration time of a key
        [sr-de] Ablaufzeit des Schlüssels

    .Parameter Enable
        [sr-en] Enable a key
        [sr-de] Schlüssel aktivieren
#>

param( 
    [Parameter(Mandatory = $true)]
    [string]$VaultName,
    [Parameter(Mandatory = $true)]
    [string]$KeyName,
    [Parameter(HelpMessage="ASRDisplay(Date)")]
    [datetime]$NotBefore,
    [Parameter(HelpMessage="ASRDisplay(Date)")]
    [datetime]$Expires,
    [bool]$Enable
)

Import-Module Az.KeyVault

try{
    [string[]]$Properties = @('VaultName','Name','NotBefore','Expires','Enabled')
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                'VaultName' = $VaultName
                'Name' = $KeyName
                'Confirm' = $false
                'PassThru' = $null
    }
    
    if($PSBoundParameters.ContainsKey('NotBefore') -eq $true){
        $cmdArgs.Add('NotBefore',$NotBefore)
    }
    if($PSBoundParameters.ContainsKey('Expires') -eq $true){
        $cmdArgs.Add('Expires',$Expires)
    }
    if($PSBoundParameters.ContainsKey('Enable') -eq $true){
        $cmdArgs.Add('Enable',$Enable)
    }
    $ret = Update-AzKeyVaultKey @cmdArgs | Select-Object $Properties

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