﻿#Requires -Version 5.0
#Requires -Modules Microsoft.Online.SharePoint.PowerShell

<#
    .SYNOPSIS
        Sets the Storage quota on a multi-geo tenant
    
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
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/SharePointOnline/Common

    .Parameter GeoLocation
        [sr-en] A particular geo-location

    .Parameter StorageQuotaMB
        [sr-en] The SharePoint Online Storage Quota 
#>

param(   
    [Parameter(Mandatory = $true)]
    [string]$GeoLocation,
    [Parameter(Mandatory = $true)]
    [int64]$StorageQuotaMB
)

Import-Module Microsoft.Online.SharePoint.PowerShell

try{
    $result = Set-SPOGeoStorageQuota -GeoLocation $GeoLocation -StorageQuotaMB $StorageQuotaMB -ErrorAction Stop | Select-Object *

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