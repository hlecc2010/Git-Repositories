﻿#Requires -Version 5.0
#Requires -Modules Microsoft.Online.SharePoint.PowerShell

<#
    .SYNOPSIS
        Enables or disables Public content delivery network (CDN) or Private CDN on the tenant level
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module Microsoft.Online.SharePoint.PowerShell

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/SharePointOnline/Tenant

    .Parameter CdnType
        [sr-en] CDN type

    .Parameter Enable
        [sr-en] CDN is enabled

    .Parameter NoDefaultOrigins
#>

param( 
    [Parameter(Mandatory = $true)]
    [ValidateSet('Public', 'Private','Both')]
    [string]$CdnType,
    [bool]$Enable,
    [switch]$NoDefaultOrigins
)

Import-Module Microsoft.Online.SharePoint.PowerShell

try{
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'NoDefaultOrigins' = $NoDefaultOrigins
                            'Enable' = $Enable
                            'CdnType' = $CdnType
                            'Confirm' = $false
                            } 

    $result = Set-SPOTenantCdnEnabled @cmdArgs | Select-Object *
      
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $result
    }
    else {
        Write-Output $result 
    }    
}
catch{
    throw
}
finally{
}