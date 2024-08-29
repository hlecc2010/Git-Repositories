﻿#Requires -Version 5.0
#requires -Modules Microsoft.Graph.DeviceManagement 

<#
    .SYNOPSIS        
        Get Device Compliance Policy Setting State Summaries from Device Management

    .DESCRIPTION          

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Modules Microsoft.Graph.DeviceManagement 

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/MS%20Graph/DeviceManagement/Policies

    .Parameter SettingStateSummaryId
        [sr-en] Id of device management compliance policy
        [sr-de] Id der Device Management Compliance Policy
#>

param( 
    [string]$SettingStateSummaryId 
)

Import-Module Microsoft.Graph.DeviceManagement 

try{
    [hashtable]$cmdArgs = @{ErrorAction = 'Stop'}

    if($PSBoundParameters.ContainsKey('SettingStateSummaryId') -eq $true){
        $cmdArgs.Add('DeviceCompliancePolicySettingStateSummaryId',$SettingStateSummaryId)
    }
    else{
        $cmdArgs.Add('All',$null)
    }
    $result = Get-MgDeviceManagementDeviceCompliancePolicySettingStateSummary @cmdArgs | Select-Object *

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $result
    }
    else{
        Write-Output $result
    }
}
catch{
    throw 
}
finally{
}